import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ringtounsi_mobile/model/coach.dart';
import 'dart:convert';
import '../utils/constants.dart';

import 'package:ringtounsi_mobile/view/CoachDetailPage.dart';

class SearchCoachScreen extends StatefulWidget {
  @override
  _SearchCoachScreenState createState() => _SearchCoachScreenState();
}

class _SearchCoachScreenState extends State<SearchCoachScreen> {
  List<Coach> coaches = [];

  @override
  void initState() {
    super.initState();
    // Appeler la fonction de récupération des coachs au chargement de l'écran
    fetchCoaches();
  }

  Future<void> fetchCoaches() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/v1/coaches/'));
      if (response.statusCode == 200) {
        final List<dynamic> coachesData = jsonDecode(response.body);

        setState(() {
          coaches = coachesData.map((data) => Coach.fromJson(data)).toList();
        });
      } else {
        // Handle error cases
        print('Failed to fetch coaches: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or server-side errors
      print('Error fetching coaches: $error');
    }
  }

  /* void _onCoachSelected(Coach coach) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CoachDetailPage(coachData: coach)),
                              );
                            
                      }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chercher un Coach'),
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
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Chercher un coach par nom ',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (text) {
                  // Action lors de la saisie dans la barre de recherche
                  // Vous pouvez implémenter la logique de recherche ici
                  // Par exemple, vous pouvez filtrer la liste des coachs en fonction du texte saisi
                  if (text.isEmpty) {
                    // Si le champ de recherche est vide, réinitialisez la liste des coachs
                    fetchCoaches();
                  } else {
                    List<Coach> filteredCoaches = coaches
                        .where((coach) => coach.nom
                            .toLowerCase()
                            .contains(text.toLowerCase()))
                        .toList();
                    setState(() {
                      // Mettez à jour la liste des coachs avec le résultat du filtre
                      coaches = filteredCoaches;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: coaches.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      // Utilisez les données du coach à partir de la liste dynamique
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/gloves.png'),
                      ),
                      title: Text(coaches[index].nom),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoachDetailPage(coachData: coaches[index]),
                            ));
                        // Action à effectuer lors du clic sur un coach
                        // Naviguer vers la page de détails du coach par exemple
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
