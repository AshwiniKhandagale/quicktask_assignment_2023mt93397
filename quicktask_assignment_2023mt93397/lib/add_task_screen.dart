import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93397/task_model.dart';
import 'package:quicktask_assignment_2023mt93397/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) addTask; // Define a function parameter

  AddTaskScreen({required this.addTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late String _title;
  late DateTime _dueDate;
  late String _description;
  late bool _completed; // Updated variable for storing status

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
    _completed = false; // Set default status
    _title = ''; // Initialize _title with an empty string
    _description = '';
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _title = value ?? '',
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Due Date:'),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => _description = value ?? '',
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Status:'),
                SizedBox(width: 8.0),
                Switch(
                  value: _completed,
                  onChanged: (value) {
                    setState(() {
                      _completed = value;
                    });
                  },
                ),
                Text(_completed ? 'Complete' : 'Incomplete'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Create a new task using the entered details
                final newTask = Task(
                  title: _title,
                  dueDate: _dueDate,
                  completed: _completed,
                  description: _description,
                );

                try {
                  widget.addTask(newTask); // Call the addTask function passed from the parent
                  Navigator.pop(context); // Close the screen after adding task
                } catch (e) {
                  print('Error creating task: $e');
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
