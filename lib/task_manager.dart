import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskManager(),
    );
  }
}

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  List<String> _tasks = [];
  String _searchQuery = '';
  TextEditingController _textController = TextEditingController(); // Controller for text field

  bool _isSearching = false;

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add('[ ] $task');
        _textController.clear(); // Clear input field after adding task
      });
    } else {
      _showSnackBar('Please enter a task!');
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index] = _tasks[index].startsWith('[ ] ')
          ? '[X] ${_tasks[index].substring(4)}'
          : '[ ] ${_tasks[index].substring(4)}';
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredTasks = _tasks
        .where((task) => task.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              )
            : Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController, // Assign controller to text field
              onChanged: (value) {
                setState(() {
                  // No need to set _newTask here
                  // _newTask = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter a new task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addTask(_textController.text), // Use text from controller
              child: Text('Add Task'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(filteredTasks[index]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      }
                    },
                    child: ListTile(
                      title: Text(
                        filteredTasks[index].substring(4),
                        style: TextStyle(
                          fontSize: 18.0,
                          decoration: filteredTasks[index].startsWith('[X] ')
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        value: filteredTasks[index].startsWith('[X] '),
                        onChanged: (_) => _toggleTask(index),
                      ),
                      tileColor: Colors.grey[200],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
