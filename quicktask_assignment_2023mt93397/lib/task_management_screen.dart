import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93397/add_task_screen.dart';
import 'package:quicktask_assignment_2023mt93397/task_model.dart';
import 'package:quicktask_assignment_2023mt93397/task_service.dart';

class TaskManagementScreen extends StatefulWidget {
  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  late List<Task> _tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService.getTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      // Show error message to the user
      _showSnackBar('Failed to load tasks. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addTask(Task newTask) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final createdTask = await TaskService.createTask(newTask);
      setState(() {
        _tasks.add(createdTask);
        _isLoading = false; // Set isLoading to false after adding task
      });
      _showSnackBar('Task added successfully');
      
      // Reload tasks after adding a new task
      _loadTasks();
    } catch (e) {
      print('Error adding task: $e');
      // Show error message to the user
      _showSnackBar('Failed to add task. Please try again later.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteTask(Task task) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await TaskService.deleteTask(task.objectId!);
      setState(() {
        _tasks.remove(task);
      });
    } catch (e) {
      print('Error deleting task: $e');
      // Show error message to the user
      _showSnackBar('Failed to delete task. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleTaskStatus(Task task) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedTask = task.copyWith(completed: !task.completed);
      await TaskService.updateTask(updatedTask);
      setState(() {
        _tasks[_tasks.indexWhere((t) => t.objectId == task.objectId)] = updatedTask;
      });
    } catch (e) {
      print('Error updating task status: $e');
      // Show error message to the user
      _showSnackBar('Failed to update task status. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
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
        title: Text('Task Management'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(child: Text('No tasks available.'))
              : SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Due Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: _tasks
                        .map((task) => DataRow(cells: [
                              DataCell(Text(task.title)),
                              DataCell(Text(task.dueDate?.toIso8601String() ?? 'N/A')),
                              DataCell(
                                Row(
                                  children: [
                                    Text(task.completed ? 'Complete' : 'Incomplete'),
                                    IconButton(
                                      icon: Icon(Icons.toggle_on),
                                      onPressed: () => _toggleTaskStatus(task),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteTask(task),
                              )),
                            ]))
                        .toList(),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                addTask: _addTask, // Pass the _addTask function
              ),
            ),
          );
          if (newTask != null) {
            _loadTasks(); // Reload tasks after adding a new task
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
