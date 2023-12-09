import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alumni_connect_app/screens/add_post.dart';
import 'package:alumni_connect_app/screens/post_card.dart';

class Post {
  final String title;
  final String description;
  final String userName;
  final String postedDate;
  final String? imageUrl;
  final String? userProfileImageUrl;

  Post({
    required this.title,
    required this.description,
    required this.userName,
    required this.postedDate,
    this.imageUrl,
    this.userProfileImageUrl,
  });

  // Use named constructor for better readability
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Post(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userName: data['userName'] ?? '',
      postedDate: data['postedDate'] ?? '',
      imageUrl: data['imageUrl'],
      userProfileImageUrl: data['userProfileImageUrl'],
    );
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
        _scrollController.position.maxScrollExtent) {
      // You can load more posts here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // Check for no posts
          if (posts == null || posts.isEmpty) {
            return const Center(
              child: Text('No posts available.'),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () async {
            final newPost = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()),
            );

            if (newPost != null) {
              // Handle the new post
            }
          },
          backgroundColor: const Color.fromARGB(255, 40, 158, 132),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
