import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddPostScreen extends StatefulWidget {
  final int coachId;
  AddPostScreen({required this.coachId});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void save_post_data(String imageUrl) async {
    const storage = FlutterSecureStorage();
    String? authToken = await storage.read(key: "authToken");
    print(widget.coachId);

    final response = await http.post(
      Uri.parse('$apiUrl/api/v1/posts'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "coachId": widget.coachId,
        "description": "",
        "imageUrl": imageUrl,
        "videoUrl": "",
        "text": _textController.text
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe4f3e3), Color(0xff5ca9e9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _imageFile != null
                  ? SizedBox(
                      height: 200.0,
                      width: double.infinity,
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Placeholder(
                      fallbackHeight: 200.0,
                      color: Colors.grey,
                    ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _getImage(ImageSource.gallery); // Access gallery
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffe4f3e3), // Background color
                  onPrimary: Color(0xff5ca9e9), // Text color
                ),
                child: Text('Select Image/Video from Gallery'),
              ),
              SizedBox(height: 20.0),
              // Add other input fields or post content here
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter your post text here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // Implement your post functionality here
                  // You can use _imageFile to upload the selected image/video

                  if(_imageFile != null) {
                    try {
                      CloudinaryResponse response = await cloudinary.uploadFile(
                        CloudinaryFile.fromFile(_imageFile!.path,
                            resourceType: CloudinaryResourceType.Image),
                      );

                      save_post_data(response.secureUrl);
                    } on CloudinaryException catch (e) {
                      print(e.message);
                      print(e.request);
                    }

                    setState(() {
                      _imageFile = null;
                    });
                  }

                  else save_post_data("");
                  _textController.clear();

                  Fluttertoast.showToast(
                      msg: "Post has been uploaded",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffe4f3e3), // Background color
                  onPrimary: Color(0xff5ca9e9), // Text color
                ),
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
