import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
                decoration: InputDecoration(
                  hintText: 'Enter your post text here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Implement your post functionality here
                  // You can use _imageFile to upload the selected image/video
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
