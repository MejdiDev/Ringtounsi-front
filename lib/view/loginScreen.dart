import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ringtounsi_mobile/view/regScreen.dart';
import 'package:ringtounsi_mobile/view/firstScreen.dart';
import 'package:ringtounsi_mobile/view/dashboard_screen.dart';
import 'package:ringtounsi_mobile/view/CoachScreen.dart';
import 'package:ringtounsi_mobile/view/PendingScreen.dart';
import 'package:ringtounsi_mobile/view/DeniedScreen.dart';
import 'package:ringtounsi_mobile/view/coachView/coachDashboard.dart';

import '../viewmodel/login_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:ringtounsi_mobile/model/user.dart';
import '../utils/constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginViewModel loginViewModel = LoginViewModel();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<User?> login(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/v1/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      if (data != null) {
        return User.fromJson(data);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ListView(
                  // Use a ListView for scrollability
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        labelText: 'Gmail',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5ca9e9),
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5ca9e9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff281537),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    GestureDetector(
                      onTap: () async {
                        print('Login button tapped');
                        String email = emailController.text;
                        String password = passwordController.text;
                        BuildContext currentContext = context;

                        // Perform login
                        User? user =
                            await login(currentContext, email, password);

                        if (user != null) {
                          const storage = FlutterSecureStorage();
                          await storage.write(key: "authToken", value: user.token);
                          await storage.write(key: "userId", value: user.id.toString());

                          // Login successful
                          if (user.role == 'Coach') {
                            // Check status for Coach role
                            if (user.status == 'approved') {
                              // Redirect to Coach Screen for approved coaches

                              Navigator.push(
                                currentContext,
                                MaterialPageRoute(
                                  builder: (currentContext) => CoachDashboard(
                                    user: user,
                                  ),
                                ),
                              );
                            } else if (user.status == 'pending') {
                              // Show pending screen for pending approval
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                currentContext,
                                MaterialPageRoute(
                                  builder: (currentContext) => PendingScreen(),
                                ),
                              );
                            } else if (user.status == 'denied') {
                              // Show denied screen for denied access
                              Navigator.push(
                                currentContext,
                                MaterialPageRoute(
                                  builder: (currentContext) => DeniedScreen(),
                                ),
                              );
                            }
                          } else if (user.role == 'Admin') {
                            // Redirect to DashboardScreen for Admin role
                            Navigator.push(
                              currentContext,
                              MaterialPageRoute(
                                builder: (currentContext) =>
                                    DashboardScreen(user: user),
                              ),
                            );
                          } else if (user.role == 'Athlete') {
                            // Redirect to FirstScreen for Athlete role
                            Navigator.push(
                              currentContext,
                              MaterialPageRoute(
                                builder: (currentContext) =>
                                    FirstScreen(user: user),
                              ),
                            );
                          } else {
                            // Handle other roles or scenarios here
                          }
                        } else {
                          // Login failed, show an error message or handle accordingly
                          print('Login failed');
                        }
                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xffe4f3e3), Color(0xff5ca9e9)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Don't have an account?",
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
                                  builder: (context) => RegScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign up",
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
    );
  }
}
