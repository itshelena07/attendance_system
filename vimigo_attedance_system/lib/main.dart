import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:vimigo_attedance_system/UserDataModel.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UserDataModel> userData = []; // List to store parsed user data

  @override
  void initState() {
    super.initState();
    // Call the method to load user data when the widget is initialized
    loadUserData();
  }

  // Method to load user data from JSON file and parse it into UserDataModel
  void loadUserData() async {
    try {
      // Read JSON data from file
      String jsonData =
          await root_bundle.rootBundle.loadString('json/userlist.json');
      // Parse JSON data into a list of maps
      List<dynamic> jsonList = json.decode(jsonData);

      // Parse each map into UserDataModel and add to the list
      List<UserDataModel> tempList = [];
      jsonList.forEach((jsonMap) {
        UserDataModel userDataModel = UserDataModel.fromJson(jsonMap);
        tempList.add(userDataModel);
      });

      // Update the state with the parsed user data
      setState(() {
        userData = tempList;
      });
    } catch (e) {
      print('Error loading user data: $e');
      // Handle error loading user data
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data'),
        ),
        body: ListView.builder(
          itemCount: userData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(userData[index].user),
              subtitle: Text(userData[index].phone),
              trailing: Text(userData[index].timeAgo),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
