import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:health_care/admin/Users/UsersForm.dart';
import 'package:health_care/models/User.dart';
import 'package:http/http.dart' as http;
// Import model User

class AdminUsers extends StatefulWidget {
  @override
  _AdminUsersState createState() => _AdminUsersState();
  static String routeName = "/users_admin";
}

class _AdminUsersState extends State<AdminUsers> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers(context).then((value) {
      setState(() {
        users = demoUsers;
      });
    });
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3001/api/user/delete-user/$id'),
    );
    if (response.statusCode == 200) {
      setState(() {
        // users.removeWhere((user) => user.id == id);
      });
    } else {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> addUser(User user) async {
    final response = await http.post(
      Uri.parse('http://localhost:3001/api/user/sign-up'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 201) {
      setState(() {
        // users.add(User.fromJson(json.decode(response.body)));
      });
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('http://localhost:3001/api/user/update-user/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      setState(() {
        // int index = users.indexWhere((u) => u.id == user.id);
        // if (index != -1) {
        //   users[index] = User.fromJson(json.decode(response.body));
        // }
      });
    } else {
      throw Exception('Failed to update user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Users'),
      ),
      body: users.isEmpty
      ? Center(child: Image.asset('assets/images/loadingflower.gif'))
      :
      ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text('Name: ${user['name']?? 'No Name'}'),
            subtitle: Text('Email: ${user['email']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //   icon: Icon(Icons.edit),
                //   onPressed: () async {
                //     User? updatedUser = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => UserForm(user: user['_id']),
                //       ),
                //     );
                //     if (updatedUser != null) {
                //       updateUser(updatedUser);
                //     }
                //   },
                // ),
                // IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: () {
                //     deleteUser(user['_id']);
                //   },
                // ),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     User? newUser = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => UserForm(),
      //       ),
      //     );
      //     if (newUser != null) {
      //       addUser(newUser);
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
