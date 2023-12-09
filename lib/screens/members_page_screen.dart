import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/dialogs.dart';
import '../styles.dart';
import '../models/chat_user.dart';
import '../api/apis.dart';

class MembersPageScreen extends StatefulWidget {
  const MembersPageScreen({super.key});

  @override
  State<MembersPageScreen> createState() => _MembersPageScreenState();
}

class _MembersPageScreenState extends State<MembersPageScreen> {
  List<Map<String, dynamic>> _list = [];
  final List<Map<String, dynamic>> _searchList = [];

  String yearFilter = 'All';
  String branchFilter = 'All';

  bool _isSearching = false;

  void _makeList(List<QueryDocumentSnapshot<Object?>> users, String yearFilter,
      String branchFilter) {
    _list.clear();

    for (var userDoc in users) {
      var userData = userDoc.data() as Map<String, dynamic>;
      var userEmail = userData['email'] as String;

      var year = userEmail.substring(0, 2);
      var branch = userEmail.substring(2, 5);

      bool matchesYear = yearFilter == 'All' || year == yearFilter.substring(2);
      bool matchesBranch = branchFilter == 'All' ||
          branch == 'b${branchFilter.toLowerCase().substring(0, 2)}';
      print('######');
      print(yearFilter);
      print(branchFilter);

      if (matchesYear && matchesBranch) {
        _list.add(userData);
      }
    }
  }

  void _changeFilter(String newYearFilter, String newBranchFilter) {
    setState(() {
      if (newYearFilter != '') yearFilter = newYearFilter;
      if (newBranchFilter != '') branchFilter = newBranchFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
          scale: 0.6,
          child: SvgPicture.asset('assets/icons/members.svg'),
        ),
        elevation: 0,
        backgroundColor: GlobalVariables.appBarColor,
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: accent_color1,
          ),
          top: BorderSide(
            width: 1,
            color: accent_color1,
          ),
        ),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                //when search text changes then updated search list
                onChanged: (val) {
                  //search logic
                  _searchList.clear();

                  for (var i in _list) {
                    if (i['name'].toLowerCase().contains(val.toLowerCase()) ||
                        i['email'].toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                      setState(() {
                        _searchList;
                      });
                    }
                  }
                },
              )
            : const Text(
                'Members',
                style: TextStyle(
                    fontSize: page_title_size,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
        actions: [
          //search user button
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: background_color1,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final users = snapshot.data!.docs;
            ChatUser loggedInUser = APIs.me;
            _makeList(users, yearFilter, branchFilter);

            return Column(
              children: [
                const SizedBox(height: 20),
                FilterBar(changeFilter: _changeFilter),
                _list.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          // itemCount: users.length,
                          itemCount:
                              _isSearching ? _searchList.length : _list.length,
                          itemBuilder: (context, index) {
                            var userData =
                                users[index].data() as Map<String, dynamic>;
                            var userId = _isSearching
                                ? _searchList[index]['id']
                                : _list[index]['id'];
                            var name = _isSearching
                                ? _searchList[index]['name']
                                : _list[index]['name'];
                            var email = _isSearching
                                ? _searchList[index]['email']
                                : _list[index]['email'];
                            var about = _isSearching
                                ? _searchList[index]['about']
                                : _list[index]['about'];
                            var image = _isSearching
                                ? _searchList[index]['image']
                                : _list[index]['image'];

                            print(name);
                            print(loggedInUser.name);

                            if (userId == loggedInUser.id) {
                              return const SizedBox();
                            }
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        background_color2.withOpacity(0.2),
                                    backgroundImage: NetworkImage(image),
                                  ),
                                  title: Text(name),
                                  subtitle: Text(about),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await APIs.addChatUser(email)
                                          .then((value) {
                                        if (!value) {
                                          Dialogs.showSnackbar(
                                              context, 'User does not Exists!');
                                        } else {
                                          Dialogs.showSnackbar(context,
                                              'Created a New Chat in Messages Tab');
                                        }
                                      });
                                    },
                                    icon: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.teal,
                                        BlendMode.srcIn,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/add_chat.svg',
                                        semanticsLabel: 'Add Chat',
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text('No Other Members Found!',
                            style: TextStyle(fontSize: 20)),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  FilterBar({super.key, required this.changeFilter});

  void Function(String, String) changeFilter;

  String yearValue = 'All';
  String branchValue = 'All';

  final List<String> years = ['All'];
  final List<String> branches = ['All', 'DSAI', 'CSE', 'ECE'];

  void _addYears() {
    int currentYear = DateTime.now().year;
    for (int year = 2019; year <= currentYear; year++) {
      years.add(year.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _addYears();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 50,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2, color: accent_color1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2, color: accent_color1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2, color: accent_color1),
                ),
                label: const Text('Year'),
                labelStyle: const TextStyle(color: accent_color1),
                contentPadding: const EdgeInsets.all(10),
                prefixIcon: const Icon(Icons.date_range)),
            value: yearValue,
            elevation: 0,
            borderRadius: BorderRadius.circular(10),
            items: years.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              yearValue = newValue!;
              print(yearValue);
              changeFilter(newValue, '');
            },
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          height: 50,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2, color: accent_color1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2, color: accent_color1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2, color: accent_color1),
                ),
                label: const Text('Branch'),
                labelStyle: const TextStyle(color: accent_color1),
                contentPadding: const EdgeInsets.all(10),
                prefixIcon: const Icon(Icons.date_range)),
            value: yearValue,
            elevation: 0,
            borderRadius: BorderRadius.circular(10),
            items: branches.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              yearValue = newValue!;
              print(yearValue);
              changeFilter('', newValue);
            },
          ),
        ),
      ],
    );
  }
}
