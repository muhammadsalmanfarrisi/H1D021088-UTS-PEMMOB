import 'package:crud_flutter/edit_data.dart';
import 'package:crud_flutter/list_data.dart';
import 'package:crud_flutter/login_page.dart';
import 'package:crud_flutter/splash.dart';
import 'package:crud_flutter/tambah_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SalmanFarrisi App CRUD',
      home: ListData(),
    );
  }
}
