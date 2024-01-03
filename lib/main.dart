import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ringtounsi_mobile/view/WelcomeScreen.dart';
import 'package:ringtounsi_mobile/view/auth_provider.dart';
import 'package:ringtounsi_mobile/view/firstScreen.dart';
import 'package:ringtounsi_mobile/view/loginScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          WelcomeScreen(), // Définir la page de connexion comme page d'accueil
    );
  }
}
