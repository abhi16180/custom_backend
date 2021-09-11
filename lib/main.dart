import 'dart:convert';

import 'package:customdb/usermodel/user.dart';
import 'package:customdb/usermodel/userlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: App(),
    theme: ThemeData(
      brightness: Brightness.dark,
    ),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

UserList? userlistInstance;

class _AppState extends State<App> {
  // ignore: prefer_typing_uninitialized_variables
  var resp;
  var userDataList = [];
  var client = http.Client();
  TextEditingController userController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  Future _fetchData() async {
    resp = await client
        .get(Uri.parse('https://pacific-beyond-59033.herokuapp.com/get'));
    userlistInstance = UserList.fromJson(jsonDecode(resp.body) as List);
    userDataList = userlistInstance!.userList as List;
  }

  Future add(String uname, String email) async {
    var jsonData = User(username: uname, email: email).toJson();
    var uriResponse = await client.post(
      Uri.parse('https://pacific-beyond-59033.herokuapp.com/add'),
      body: jsonData,
    );
  }

  Future deleteData() async {
    await client
        .delete(Uri.parse('https://pacific-beyond-59033.herokuapp.com/delete'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MongoDB')),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: userDataList.length,
                itemBuilder: (context, item) {
                  return ListTile(
                    title: Text(userDataList[item].username.toString()),
                    subtitle: Text(userDataList[item].email.toString()),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.more),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.add),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (contex) {
                      return AlertDialog(
                        title: Center(child: Text('Add user details here')),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        actions: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: userController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                              ),
                            ),
                          ),
                          Center(
                            child: MaterialButton(
                              child: Text('ADD'),
                              onPressed: () async {
                                await add(
                                    userController.text, emailController.text);
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      );
                    });
              }),
          SpeedDialChild(
              child: const Icon(Icons.delete),
              onTap: () async {
                await deleteData();
                setState(() {});
              }),
          SpeedDialChild(
            child: const Icon(Icons.refresh),
            onTap: () => setState(() {}),
          )
        ],
      ),
    );
  }
}
