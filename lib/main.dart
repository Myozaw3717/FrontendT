import 'package:flutter/material.dart';
import 'package:flutter_exe/screen/category_form.dart';
import 'package:flutter_exe/screen/test.dart';
import 'package:flutter_exe/screen/user_form.dart';
import 'package:flutter_exe/screen/user_list.dart';
import 'package:flutter_exe/screen/user_table.dart';
import 'package:flutter_exe/screen/user_table_with_api.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserForm(),
    );
  }
}