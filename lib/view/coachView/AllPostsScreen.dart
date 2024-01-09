import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/constants.dart';

class Post {
  final int id;
  final String nom;
  final String prenom;
  final String text;
  final String? imageUrl; // Path to image or video

  Post({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.text,
    this.imageUrl,
  });
}

class AllPostsScreen extends StatefulWidget {

  @override
  _AllPostsScreenState createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  List posts = [];
  static const storage = FlutterSecureStorage();

  void _get_posts() async {
    String? authToken = await storage.read(key: "authToken");

    final response = await http.get(
      Uri.parse('$apiUrl/api/v1/posts'),
      headers: {
        'Authorization': 'Bearer $authToken'
      },
    );

    if(response.statusCode == 200) {
      List res = jsonDecode(response.body);
      print(res);

      setState(() {
        posts = res;
      });
    }
  }

  @override
  void initState() {
    _get_posts();
    super.initState();
  }

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
            children: posts.reversed.map((post) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(post["nom"] + post["prenom"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post["text"]),
                      SizedBox(height: 8),
                      if (post["imageUrl"] != null)
                        Image.network(
                          (post["imageUrl"]!.toString().isEmpty ? "https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg" : post["imageUrl"]),
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
                                    onPressed: () async {
                                      String? authToken = await storage.read(key: "authToken");
                                      print(post["id"]);

                                      final response = await http.delete(
                                        Uri.parse('$apiUrl/api/v1/posts/${post["id"]}'),
                                        headers: {
                                          'Authorization': 'Bearer $authToken'
                                        },
                                      );

                                      print(response.body);
                                      Navigator.of(context).pop();
                                      _get_posts();

                                      Fluttertoast.showToast(
                                          msg: "Post has been deleted !",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
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
