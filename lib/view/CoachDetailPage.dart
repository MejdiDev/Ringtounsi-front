import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ringtounsi_mobile/model/coach.dart';
import 'package:ringtounsi_mobile/model/user.dart';
import 'package:ringtounsi_mobile/utils/constants.dart';
import 'package:ringtounsi_mobile/view/auth_provider.dart';

class CoachDetailPage extends StatefulWidget {
  final Coach coachData;
  static const storage = FlutterSecureStorage();
  CoachDetailPage({required this.coachData});

  @override
  State<CoachDetailPage> createState() => _CoachDetailPageState();
}

class _CoachDetailPageState extends State<CoachDetailPage> {
  List<dynamic> comments = [];
  double rating = 0.5;

  double averageRating = 2.5;

  void _get_comments() async {
    String? authToken = await CoachDetailPage.storage.read(key: "authToken");

    final response = await http.get(
      Uri.parse('$apiUrl/api/v1/users/coach-comments/${widget.coachData.id}'),
      headers: {
        'Authorization': 'Bearer $authToken'
      },
    );

    print(response.body);

    if(response.statusCode == 200) {
      double averageRes = 0;
      List res = jsonDecode(response.body);

      res.forEach((item) {
        averageRes += item["rating"];
      });

      averageRes = averageRes / res.length;

      setState(() {
        comments = res;
        averageRating = averageRes;
      });
    }
  }

   TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _get_comments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Coach'),
        backgroundColor: Color.fromARGB(0, 184, 23, 55),
      ),
      body: Container(
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Card(
                    color: Colors.white.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/boxe.jpg'),
                          ),
                          SizedBox(height: 16.0),
                          ListTile(
                            title: Text(
                              widget.coachData.nom,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.category),
                                    SizedBox(width: 4.0),
                                    Text('Catégorie de Boxing'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IgnorePointer(
                                      child: RatingBar.builder(
                                        initialRating: averageRating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 16,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Update the coach's rating
                                        },
                                      ),
                                    ),
                                    Text(" 2"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 4.0),
                                    Text('Adresse du Coach'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Description du Coach',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Commentaires et Avis',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length, // Assuming coachData.comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];

                              return ListTile(
                                title: Text('${comment["user"]["nom"]} ${comment["user"]["prenom"]}'), // Assuming userName exists in Comment model),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IgnorePointer(
                                          child: RatingBar.builder(
                                            initialRating: comment["rating"].toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 16,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(comment["comment"]),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Row(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: RatingBar.builder(
                      initialRating: rating,
                      minRating: 0.5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 45,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Ajouter un commentaire...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                           _submitComment();

                        },
                        child: Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _submitComment() async {
  String? userId = await CoachDetailPage.storage.read(key: "userId");
  String? authToken = await CoachDetailPage.storage.read(key: "authToken");

  try {
    if (userId == null || widget.coachData.id == null) {
      print('Connected user ID or coach ID is null.');
      return;
    }
    final int coachId = widget.coachData.id;
    final String commentText = commentController.text;

    final response = await http.post(
      Uri.parse('$apiUrl/api/v1/users/add-comment'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'userId': userId,
        'coachId': coachId,
        'comment': commentText,
        'rating': rating
      }),
    );

    if (response.statusCode == 200) {
      print('Comment has been submitted successfully!');
      commentController.clear();
      _get_comments();

      setState(() {
        rating = 0.5;
      });

      Fluttertoast.showToast(
          msg: "Comment has been submitted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      print('Failed to submit comment. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error submitting comment: $error');
  }
}
}
