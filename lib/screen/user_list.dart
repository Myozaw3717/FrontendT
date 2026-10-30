import 'package:flutter/material.dart';
import 'package:flutter_exe/model/user_data.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});
   static const users=[
    User(
      name: 'John Doe',
      email: 'john.doe@example.com',
      role: 'Admin'
    ),
    User(
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      role: 'editor'
    ),
    User(
      name: 'Bob Johnson',
      email: 'bob.johnson@example.com',
      role: 'user'
    ),
   ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Text(user.role),
            ),
          );
        },
      ),
    );
  }
}