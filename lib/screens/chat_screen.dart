import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:alumni_connect_app/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/frostedGlassBox.dart';
import '../widgets/message_card.dart';
import 'view_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            //app bar
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              elevation: 10,
              shadowColor: Colors.black,
              backgroundColor: Colors.transparent,
            ),

            backgroundColor: const Color.fromARGB(255, 234, 248, 255),

            //body
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // image: AssetImage("assets/images/splash_bg.jpg"),
                  image: AssetImage("assets/images/bg2.jpg"),
                  fit: BoxFit.cover,
                  // opacity: 0.5,
                ),
                // color: Colors.red.withOpacity(0.5),
              ),
              child: Container(
                color: Colors.black45,
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: APIs.getAllMessages(widget.user),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            //if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const SizedBox();

                            //if some or all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data
                                      ?.map((e) => Message.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                    reverse: true,
                                    itemCount: _list.length,
                                    padding:
                                        EdgeInsets.only(top: mq.height * .01),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return MessageCard(message: _list[index]);
                                    });
                              } else {
                                return const Center(
                                  child: Text('Say Hii! 👋',
                                      style: TextStyle(fontSize: 20)),
                                );
                              }
                          }
                        },
                      ),
                    ),

                    //progress indicator for showing uploading
                    if (_isUploading)
                      const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))),

                    //chat input filed
                    _chatInput(),

                    //show emojis on keyboard emoji button click & vice versa
                    if (_showEmoji)
                      SizedBox(
                        height: mq.height * .35,
                        child: EmojiPicker(
                          textEditingController: _textController,
                          config: Config(
                            bgColor: const Color.fromARGB(255, 234, 248, 255),
                            columns: 8,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => ViewProfileScreen(user: widget.user)));
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ViewProfileScreen(user: widget.user);
            },
          );
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.4),
                      // Colors.white.withOpacity(0.5),
                      // Colors.black.withOpacity(0.5),
                      // Colors.teal.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    // begin: Alignment.topCenter,
                    end: Alignment.topRight,
                    // end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  // border: const Border(
                  //   bottom: BorderSide(
                  //     color: Colors.white,
                  //     width: 1,
                  //   ),
                  //   left: BorderSide(
                  //     color: Colors.white,
                  //     width: 2,
                  //   ),
                  //   right: BorderSide(
                  //     color: Colors.white,
                  //     width: 2,
                  //   ),
                  // ),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  children: [
                    //back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    ),

                    //user profile picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .03),
                      child: CachedNetworkImage(
                        width: mq.height * .05,
                        height: mq.height * .05,
                        imageUrl:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                      ),
                    ),

                    //for adding some space
                    const SizedBox(width: 10),

                    //user name & last seen time
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //user name
                          Text(
                            list.isNotEmpty ? list[0].name : widget.user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          //for adding some space
                          const SizedBox(height: 2),

                          //last seen time of user
                          Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : MyDateUtil.getLastActiveTime(
                                        context: context,
                                        lastActive: list[0].lastActive)
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget.user.lastActive),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              color: Colors.transparent,
              child: FrostedGlassBox(
                height: 50,
                width: double.maxFinite,
                color: Colors.white,
                child: Row(
                  children: [
                    //emoji button
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.amberAccent,
                        size: 25,
                      ),
                    ),

                    Expanded(
                        child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                          hintText: 'Type Message...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    )),

                    //pick image from gallery button
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Picking multiple images
                          final List<XFile> images =
                              await picker.pickMultiImage(imageQuality: 70);

                          // uploading & sending image one by one
                          for (var i in images) {
                            log('Image Path: ${i.path}');
                            setState(() => _isUploading = true);
                            await APIs.sendChatImage(widget.user, File(i.path));
                            setState(() => _isUploading = false);
                          }
                        },
                        icon: const Icon(Icons.image,
                            color: Colors.grey, size: 26)),

                    //take image from camera button
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 70);
                          if (image != null) {
                            log('Image Path: ${image.path}');
                            setState(() => _isUploading = true);

                            await APIs.sendChatImage(
                                widget.user, File(image.path));
                            setState(() => _isUploading = false);
                          }
                        },
                        icon: const Icon(Icons.camera_alt_rounded,
                            color: Colors.grey, size: 26)),

                    //adding some space
                    SizedBox(width: mq.width * .02),
                  ],
                ),
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 12, bottom: 10, right: 10, left: 8),
            shape: const CircleBorder(),
            // color: accent_color1.withOpacity(0.8),
            // color: accent_color1,
            color: accent_color1,
            elevation: 10,
            child: const Icon(CupertinoIcons.paperplane_fill,
                color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
