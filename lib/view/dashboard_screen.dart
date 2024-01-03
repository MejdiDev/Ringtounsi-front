import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/coach.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Coach> coaches = []; // List to store fetched coaches

  Color getStatusColor(String status) {
    if (status == 'approved') {
      return Colors.green;
    } else if (status == 'denied') {
      return Colors.red;
    } else {
      return Colors.amber;
    }
  }

  Future<void> updateCoachStatus(String coachId, String coachStatus) async {
    String newStatus = getNextStatus(coachStatus);
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/v1/coaches/id/$coachId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        await fetchCoaches(); // Fetch updated data
        setState(() {}); // Trigger a rebuild of the UI
      } else {
        print('Failed to update coach status: ${response.statusCode}');
        // Handle error cases here
      }
    } catch (error) {
      print('Error updating coach status: $error');
      // Handle network or server-side errors here
    }
  }

  String getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return 'approved';
      case 'approved':
        return 'denied';
      case 'denied':
        return 'pending';
      default:
        return 'approved'; // Set the default status here if needed
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCoaches(); // Fetch coaches when the screen initializes
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

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Row(
          children: [
            //Let's start by adding the Navigation Rail
            NavigationRail(
                extended: isExpanded,
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                unselectedIconTheme:
                    IconThemeData(color: Colors.white, opacity: 1),
                unselectedLabelTextStyle: TextStyle(
                  color: Colors.white,
                ),
                selectedIconTheme:
                    IconThemeData(color: Colors.deepPurple.shade900),
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.contacts),
                    label: Text("Coaches"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text("All users"),
                  ),
                ],
                selectedIndex: 0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(60.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //let's add the navigation menu for this project
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              //let's trigger the navigation expansion
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            icon: Icon(Icons.menu),
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D"),
                            radius: 26.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      // Add the title here
                      Center(
                        child: Text(
                          'Coaches List',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      //Now let's start with the dashboard main rapports
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //add here
                        ],
                      ),
                      //Now let's set the article section
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [],
                          ),
                          Container(
                            width: 300.0,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Type Article Title",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      //let's set the filter section

                      SizedBox(
                        height: 20.0,
                      ),
                      //Now let's add the Table
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey.shade200),
                            columns: [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("FirstName")),
                              DataColumn(label: Text("LastName")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text("Status")),
                            ],
                            rows: coaches.map((coach) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(coach.id.toString())),
                                  DataCell(Text(coach.nom)),
                                  DataCell(Text(coach.prenom)),
                                  DataCell(Text(coach.email)),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        updateCoachStatus(
                                            coach.id.toString(), coach.status);
                                      },
                                      child: Text(coach.status),
                                      style: ElevatedButton.styleFrom(
                                        primary: getStatusColor(coach.status),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          //Now let's set the pagination
                          SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "1",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "2",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "3",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "See All",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //let's add the floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
