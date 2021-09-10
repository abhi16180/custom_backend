import 'dart:convert';

import 'package:customdb/usermodel/user.dart';
import 'package:customdb/usermodel/userlist.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: App(),
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
  var userDataList;
  var client = http.Client();
  Future _fetchData() async {
    resp = await client
        .get(Uri.parse('https://boiling-caverns-84229.herokuapp.com/get'));
    userlistInstance = UserList.fromJson(jsonDecode(resp.body) as List);
    userDataList = userlistInstance!.userList;
  }

  Future add() async {
    var jsonData = User(username: 'username', email: 'email email').toJson();
    var uriResponse = await client.post(
      Uri.parse('https://boiling-caverns-84229.herokuapp.com/add'),
      body: jsonEncode(jsonData),
    );

    print(uriResponse.body.toString());
  }

  Future deleteData() async {
    await client.delete(
        Uri.parse('https://boiling-caverns-84229.herokuapp.com/delete'));
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
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: userDataList.length,
                itemBuilder: (context, item) {
                  return ListTile(
                    title: Text(userDataList[item].username.toString()),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          FloatingActionButton(
            onPressed: () async {
              await add();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              await deleteData();
              setState(() {});
            },
            child: const Icon(Icons.delete),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
