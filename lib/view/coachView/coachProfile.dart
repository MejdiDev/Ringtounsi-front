import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ringtounsi_mobile/view/LevelScreen.dart';
import 'package:ringtounsi_mobile/view/SearchCoachScreen.dart';
import '../../model/user.dart';
import '../firstScreen.dart';
import '../../utils/constants.dart';

class CoachProfileScreen extends StatefulWidget {
  final User user;

  CoachProfileScreen({required this.user});

  @override
  _CoachProfileScreenState createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  late String _coverPhoto;

  @override
  void initState() {
    super.initState();
    _coverPhoto = 'assets/profile.jpg';
  }

  // Function to update user details
  Future<void> updateUser() async {
    Uri Url =
        Uri.parse('http://192.168.1.22:3000/api/v1/users/id/${widget.user.id}');

    try {
      final http.Response response = await http.patch(
        Url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': 'Bearer ${widget.user.}',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': widget.user.nom,
          'prenom': widget.user.prenom,
          'bio': widget.user.bio,
          'email': widget.user.email,
          /*'birthDate': widget.user.birthDate.toString(),*/
          'grade': widget.user.grade,
          'adresse': widget.user.adresse,
          'numTel': widget.user.numTel,
          /* 'boxingCategory': widget.user.boxingCategory,*/
          // Add other fields as needed
        }),
      );

      if (response.statusCode == 200) {
        // Successful update
        print('User updated successfully');
        // You can update local state or show a success message here
      } else {
        // Handle the error, show an error message, etc.
        print('Failed to update user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating user: $error');
      // Handle the error, show an error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    _coverPhoto,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '${widget.user.nom} ${widget.user.prenom}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ProfileInfoItem(
              icon: Icons.bookmark,
              text: 'Bio: ${widget.user.bio}',
            ),
            ProfileInfoItem(
              icon: Icons.grade,
              text: 'Grade: ${widget.user.grade}',
            ),
            ProfileInfoItem(
              icon: Icons.email,
              text: 'Email: ${widget.user.email}',
            ),
            ProfileInfoItem(
              icon: Icons.house,
              text: 'Adresse: ${widget.user.adresse}',
            ),
            ProfileInfoItem(
              icon: Icons.phone,
              text: 'Phone: ${widget.user.numTel}',
            ),
            // Add more ProfileInfoItems for other details
            ElevatedButton(
              onPressed: () {
                _editProfile(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffe4f3e3), // Background color
                onPrimary: Color(0xff5ca9e9), // Text color
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit,
                    color: Color(0xff5ca9e9),
                  ),
                  SizedBox(width: 8),
                  Text('Edit Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  initialValue: widget.user.nom,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.nom = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  initialValue: widget.user.prenom,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.prenom = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bio'),
                  initialValue: widget.user.bio,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.bio = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  initialValue: widget.user.email,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.email = value;
                    });
                  },
                ),
                // Ajout de nouveaux champs
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  // initialValue: widget.user.birthDate.toLocal().toString().split(' ')[0],
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      // widget.user.birthDate = DateTime.parse(value);
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Grade'),
                  initialValue: widget.user.grade,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.grade = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  initialValue: widget.user.adresse,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.adresse = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  initialValue: widget.user.numTel,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      widget.user.numTel = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Boxing Category'),
                  // initialValue: widget.user.boxingCategory,
                  onChanged: (value) {
                    // Update the user object with the new value
                    setState(() {
                      // widget.user.boxingCategory = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add logic to save changes to the profile
                updateUser(); // Call the updateUser function to send the API request
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(112, 255, 255, 255),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
