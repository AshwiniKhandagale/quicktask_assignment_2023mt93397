import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Task {
  final String title;
  final DateTime dueDate;
   bool status;
  final String description;

  Task({
    required this.title,
    required this.dueDate,
    required this.status,
    required this.description,
  });
}

class TaskManagementScreen extends StatefulWidget {
  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  List<Task> tasks = [];
static const String parseServerUrl = 'https://parseapi.back4app.com';
  static const String applicationId = '5vXrHKZdEuWgjUXybjx96svTDGDXf1839QpZtKt0';
  static const String restApiKey = 'c4vdvwqXh34VeCHLq0M1W2un004Zf1ZXoqTkZWWs';
  static const String clientKey = 'Y68L9vISTrsYsMmCmDCZ2DDcXUWfJicxkK4IZVLW';
  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen loads
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(
      Uri.parse('$parseServerUrl/tasks'),
      headers: {
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'X-Parse-Client-Key': clientKey,
      },
    );

    if (response.statusCode == 200) {
      // Parse response data and populate tasks list
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<Task> fetchedTasks = responseData.map((taskData) {
        return Task(
          title: taskData['title'],
          dueDate: DateTime.parse(taskData['dueDate']),
          status: taskData['status'],
          description: taskData['description'],
        );
      }).toList();

      setState(() {
        tasks = fetchedTasks;
      });
    } else {
      // Handle error if request fails
      print('Failed to fetch tasks: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Due Date: ${task.dueDate}'),
            trailing: Checkbox(
              value: task.status,
              onChanged: (bool? value) {
                // Update task status when checkbox is toggled
                setState(() {
                  task.status = value ?? false;
                });
                // Call API to update task status
                // Implement this functionality
              },
            ),
            onTap: () {
              // Display task details or implement deletion functionality
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add task screen
          // Implement navigation to add task screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
