// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:alumni_connect_app/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'auth/login_screen.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    print(widget.user.name);
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: AppBar(
            title: const Text('Profile Screen',
                style: TextStyle(color: Colors.white)),
            backgroundColor: GlobalVariables.appBarColor,
            actions: [
              Container(
                // height: 50,
                // width: 200,
                padding: EdgeInsets.only(left: 20),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal.shade400,
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                    ),
                    onPressed: () async {
                      Dialogs.showProgressBar(context);
                      await APIs.updateActiveStatus(false);
                      await APIs.auth.signOut().then((value) async {
                        await GoogleSignIn().signOut().then((value) {
                          Navigator.pop(context);

                          Navigator.pop(context);
                          APIs.auth = FirebaseAuth.instance;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        });
                      });
                    },
                    icon: const Icon(Icons.logout),
                    label:
                        const Text('Logout', style: TextStyle(fontSize: 16))),
              )
            ],
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
          ),

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(File(_image!),
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover))
                            :

                            //image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(Icons.edit,
                                color: GlobalVariables.mainColor),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .03),

                    // user email label
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // name input field
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Imorz khan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 232, 250, 248),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        labelText: 'About',
                        hintText: 'Hey there! Let\'s chat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 232, 250, 248),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // update profile button
                    Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal.shade400,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully!');
                            });
                          }
                        },
                        icon: const Icon(Icons.edit, size: 28),
                        label: const Text('UPDATE',
                            style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: SvgPicture.asset('assets/icons/gallery.svg',
                          width: 60)),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 3,
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: SvgPicture.asset('assets/icons/camera.svg',
                          width: 60)),
                ],
              )
            ],
          );
        });
  }
}
