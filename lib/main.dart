import 'package:flutter/material.dart';
// Import the task manager file
import 'package:my_task_manager/task_manager.dart'; // Replace with your project name

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use the TaskManager widget as the home screen
      home: TaskManager(),
    );
  }
}
