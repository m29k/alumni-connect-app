import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../styles.dart';

class Post {
  final String title;
  final String description;
  final String userName;
  final String postedDate;
  final String? imageUrl;
  final String? userProfileImageUrl; // Added user profile image URL

  Post({
    required this.title,
    required this.description,
    required this.userName,
    required this.postedDate,
    this.imageUrl,
    this.userProfileImageUrl,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Post(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        userName: data['userName'] ?? '',
        postedDate: data['postedDate'] ?? '',
        imageUrl: data['imageUrl'],
        userProfileImageUrl: data['userProfileImageUrl']);
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late ScrollController _scrollController;
  late Stream<List<Post>> _postsStream;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _postsStream = _getPostsStream();
  }

  Stream<List<Post>> _getPostsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      // You can load more posts here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<Post>>(
          stream: _postsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Post>? posts = snapshot.data;

            return ListView.builder(
              itemCount: posts?.length ?? 0,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return PostCard(post: posts![index]);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newPost = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPostScreen()),
            );

            if (newPost != null) {}
          },
          backgroundColor: Color.fromARGB(255, 40, 158, 132),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final List<Post> posts;

  const PostList({required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.userProfileImageUrl != null
                  ? NetworkImage(post.userProfileImageUrl!)
                  : const AssetImage('assets/images/userImageIcon.png')
                      as ImageProvider,
            ),
            title: Text(post.userName),
            subtitle: Text(
                'Posted on: ${DateFormat.yMMMMd().add_jms().format(DateTime.parse(post.postedDate!))}'),
          ),
          if (post.imageUrl != null)
            Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(post.description),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? imageUrl;
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 5, // Set maxLines to allow multiple lines
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a detailed description...',
                border: OutlineInputBorder(), // Add border for a better look
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showImageSourceDialog();
              },
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            if (pickedImage != null)
              Image.file(
                pickedImage!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String? downloadUrl;

                // Check if an image is picked
                if (pickedImage != null) {
                  // Upload image to Firebase Storage
                  downloadUrl =
                      await _uploadImageToFirebaseStorage(pickedImage!);
                }

                // Retrieve the current user
                User? currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null) {
                  Post newPost = Post(
                      title: titleController.text,
                      description: descriptionController.text,
                      userName: currentUser.displayName ?? 'Anonymous',
                      imageUrl: downloadUrl,
                      postedDate: DateTime.now().toString(),
                      userProfileImageUrl: currentUser.photoURL);

                  await _addPostToFirestore(newPost);

                  Navigator.pop(context, newPost);
                } else {
                  print('User not signed in.');
                }
              },
              child: const Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPostToFirestore(Post newPost) async {
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'title': newPost.title,
        'description': newPost.description,
        'userName': newPost.userName,
        'imageUrl': newPost.imageUrl,
        'postedDate': newPost.postedDate,
        'userProfileImageUrl': newPost.userProfileImageUrl
      });
    } catch (e) {
      print('Error adding post to Firestore: $e');
    }
  }

  // Function to show dialog for choosing image source
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to pick an image using the image picker
  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImageFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    String folderName = 'postsImages';
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference =
        FirebaseStorage.instance.ref().child('$folderName/$fileName.jpg');

    await storageReference.putFile(imageFile);

    // Get the download URL of the uploaded image
    String downloadUrl = await storageReference.getDownloadURL();

    return downloadUrl;
  }
}
