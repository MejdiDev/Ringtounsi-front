import 'package:flutter/material.dart';
import 'package:ringtounsi_mobile/view/profile.dart';
import 'package:ringtounsi_mobile/view/firstScreen.dart';
import 'package:ringtounsi_mobile/view/LevelScreen.dart';
import 'package:ringtounsi_mobile/view/SearchCoachScreen.dart';

class LevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Types de Boxing'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe4f3e3), Color(0xff5ca9e9)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoxingDetailsPage()),
                );
              },
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    Image.asset(
                        'assets/boxe.jpg'), // Ajoutez le chemin de votre image
                    ListTile(
                      title: Text('Boxing Type 1'),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoxingDetailsPage()),
                );
              },
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    Image.asset(
                        'assets/boxe.jpg'), // Ajoutez le chemin de votre image
                    ListTile(
                      title: Text('Boxing Type 2'),
                    ),
                  ],
                ),
              ),
            ),
            // ... Ajoutez d'autres cartes pour différents types de boxing
          ],
        ),
      ),
    );
  }
}

class BoxingDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boxing Type Details'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Action à effectuer lorsque le premier élément est sélectionné
                  },
                  child: Card(
                    child: Container(
                      width: 100, // Set your preferred width
                      height: 60, // Set your preferred height
                      child: Center(
                        child: Text('Débutant'),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Action à effectuer lorsque le deuxième élément est sélectionné
                  },
                  child: Card(
                    child: Container(
                      width: 100, // Set your preferred width
                      height: 60, // Set your preferred height
                      child: Center(
                        child: Text('Intermédiaire'),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Action à effectuer lorsque le troisième élément est sélectionné
                  },
                  child: Card(
                    child: Container(
                      width: 100, // Set your preferred width
                      height: 60, // Set your preferred height
                      child: Center(
                        child: Text('Avancée'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Liste de liens vidéo
            Expanded(
              child: ListView(
                children: [
                  _buildVideoCard('Vidéo 1'),
                  _buildVideoCard('Vidéo 2'),
                  // Add more video cards here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to create the video card widget
Widget _buildVideoCard(String videoTitle) {
  return Card(
    color: Colors.black,
    child: ListTile(
      title: Text(
        videoTitle,
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.play_circle_filled,
        color: Colors.white,
      ),
      onTap: () {
        // Action to play the respective video
      },
    ),
  );
}
