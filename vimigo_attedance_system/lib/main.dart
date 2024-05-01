import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:vimigo_attedance_system/UserDataModel.dart';
import 'package:intl/intl.dart'; // for date and time formatting

class AddUserPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaveUser;

  AddUserPage({required this.onSaveUser});

  @override
  Widget build(BuildContext context) {
    String userName = '';
    String userPhone = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                userName = value;
              },
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              onChanged: (value) {
                userPhone = value;
              },
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Create UserDataModel with provided data
                UserDataModel newUser = UserDataModel(
                  user: userName,
                  phone: userPhone,
                  checkIn:
                      DateTime.now(), // Assuming current time as check-in time
                  timeAgo: 'Just now',
                );

                // Call the callback function to save the user data
                onSaveUser(newUser.toJson());

                // Close the page
                Navigator.pop(context);
              },
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}

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
  Future<void> loadUserData() async {
    try {
      final jsondata =
          await root_bundle.rootBundle.loadString('json/userlist.json');
      final list = json.decode(jsondata) as List<dynamic>;
      List<UserDataModel> tempUserData =
          list.map((e) => UserDataModel.fromJson(e)).toList();

      // Sort userData list based on check-in time in descending order
      tempUserData.sort((a, b) => b.checkIn.compareTo(a.checkIn));

      // Update the state with the loaded and sorted user data
      setState(() {
        userData = tempUserData;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Method to save user data into JSON
  void saveUserData(Map<String, dynamic> userDataJson) {
    // Add the new user data to the existing list
    setState(() {
      userData.add(UserDataModel.fromJson(userDataJson));
    });

    // Save the updated user data list into JSON file (optional)
    // You can implement saving the data to a file or API here
  }

  void _showAddUserPopup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUserPage(
          onSaveUser: saveUserData, // Pass the saveUserData function
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userData.sort((a, b) => b.checkIn.compareTo(a.checkIn));
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
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showAddUserPopup(context),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
