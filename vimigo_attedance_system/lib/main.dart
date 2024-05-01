import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:vimigo_attedance_system/UserDataModel.dart';
import 'package:intl/intl.dart'; // for date and time formatting

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UserDataModel> userData = []; // List to store parsed user data
  bool _showCheckInDetail =
      true; // Flag to toggle showing the check-in detail or time ago

  @override
  void initState() {
    super.initState();
    // Call the method to load user data when the widget is initialized
    loadUserData();
  }

  // Method to load user data from JSON file and parse it into UserDataModel
// Method to load user data from JSON file and parse it into UserDataModel
  Future<void> loadUserData() async {
    try {
      final jsondata =
          await root_bundle.rootBundle.loadString('json/userlist.json');
      final list = json.decode(jsondata) as List<dynamic>;
      List<UserDataModel> tempUserData =
          list.map((e) => UserDataModel.fromJson(e)).toList();

      // Sort the userData list based on check-in time in descending order
      tempUserData.sort((a, b) => b.checkIn.compareTo(a.checkIn));

      // Update the state with the loaded and sorted user data

      // Update the state with the loaded user data
      setState(() {
        userData = tempUserData;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data'),
        ),
        body: Center(
          child: Column(
            children: [
              ToggleButtons(
                isSelected: [
                  _showCheckInDetail,
                  !_showCheckInDetail
                ], // Ensure correct length
                onPressed: (int index) {
                  setState(() {
                    _showCheckInDetail = !_showCheckInDetail;
                  });
                },
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Check-in Detail'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Time Ago'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(userData[index].user),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userData[index].phone),
                              ],
                            ),
                          ),
                          Text(
                            _showCheckInDetail
                                ? DateFormat('dd.MM.yyyy HH:mm:ss')
                                    .format(userData[index].checkIn)
                                : userData[index].timeAgo,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
