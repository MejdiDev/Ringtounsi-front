import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ringtounsi_mobile/view/loginScreen.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  String _selectedRole = "Athlete";
  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _registrationSuccessful = false;

  Future<void> registerUser(String nom, String prenom, String email,
      String password, String role) async {
    const Url = '$apiUrl/api/v1/users';

    try {
      final response = await http.post(
        Uri.parse(Url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          'confirm_password': password,
          'role': role,
          'date_inscription': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        print('Registration successful');
        _registrationSuccessful = true;
      } else {
        print('Registration failed. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
        _registrationSuccessful = false;
      }
    } catch (e) {
      print('Error connecting to the server: $e');
      _registrationSuccessful = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, left: 22),
                    child: Text(
                      'Create Your\nAccount',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          labelText: 'Name',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5ca9e9),
                          ),
                        ),
                      ),
                      TextField(
                        controller: prenomController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          labelText: 'Prenom',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5ca9e9),
                          ),
                        ),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          labelText: 'Phone or Gmail',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5ca9e9),
                          ),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Password',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5ca9e9),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Confirm Password',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5ca9e9),
                          ),
                        ),
                        controller: confirmPasswordController,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff5ca9e9),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          underline: Container(),
                          icon: Icon(Icons.arrow_drop_down,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          onChanged: (String? value) {
                            if (value != "") {
                              setState(() {
                                _selectedRole = value!;
                              });
                            }
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: "Athlete",
                              child: Text('Athlete'),
                            ),
                            DropdownMenuItem<String>(
                              value: "Coach",
                              child: Text('Coach'),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String nom = nameController.text;
                          String prenom = prenomController.text;
                          String email = emailController.text;
                          String password = passwordController.text;
                          String confirmPassword =
                              confirmPasswordController.text;

                          if (password == confirmPassword) {
                            await registerUser(
                                nom, prenom, email, password, _selectedRole);

                            if (_registrationSuccessful) {
                              print(
                                  'Registration successful. Navigating to login page.');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            } else {
                              print('Registration failed');
                            }
                          } else {
                            print('Passwords do not match');
                          }
                        },
                        child: Text('S\'inscrire'),
                      ),
                      SizedBox(height: 80),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "You already have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
