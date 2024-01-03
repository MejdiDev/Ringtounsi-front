import 'package:flutter/material.dart';

class Post {
  final String userName;
  final String description;
  final String? imagePath; // Path to image or video

  Post({
    required this.userName,
    required this.description,
    this.imagePath,
  });
}

class AllPostsScreen extends StatefulWidget {
  final List<Post> posts;

  AllPostsScreen({required this.posts});

  @override
  _AllPostsScreenState createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe4f3e3), Color(0xff5ca9e9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            // Replaced ListView.builder with Column
            children: widget.posts.map((post) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(post.userName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.description),
                      SizedBox(height: 8),
                      if (post.imagePath != null)
                        Image.network(
                          post.imagePath!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      // Display image or video if available
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Implement edit functionality
                          // You can use post to edit the post
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implement delete functionality
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Post'),
                                content: Text(
                                    'Are you sure you want to delete this post?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.posts.remove(post);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
