import 'package:customdb/usermodel/user.dart';

class UserList {
  List<User> userList;
  UserList({required this.userList});

  factory UserList.fromJson(List<dynamic> json) {
    return UserList(
        userList:
            json.map((e) => User.fromJson(e as Map<String, dynamic>)).toList());
  }
}
