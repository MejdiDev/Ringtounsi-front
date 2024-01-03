import 'package:flutter/material.dart';
import '../model/user.dart'; // Import other pages

class CoachScreen extends StatelessWidget {
  final User user;

  const CoachScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Coach Dashboard'),
      ),
      
      body: Center(
        
        child: Text('Welcome, Coach ${user.nom}'),
      ),
    );
  }
}
