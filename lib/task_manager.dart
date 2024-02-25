import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TaskManager(),
  ));
}

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  List<String> _tasks = []; // Initial empty list
  String _searchQuery = "";

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        // Add a new task with initial uncompleted state ("[ ]")
        _tasks.add('[ ] $task');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a task!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleTask(int index) {
    setState(() {
      // Extract the task name without the checkbox state
      String taskName = _tasks[index].substring(4);
      // Update task completion status directly by checking the checkbox value
      _tasks[index] = _tasks[index].startsWith('[ ]')
          ? '[X] ${taskName.trim()}' // Trim the task name to remove leading spaces
          : '[ ] ${taskName.trim()}'; // Trim the task name to remove leading spaces
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredTasks = _tasks
        .where((task) => task.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Task Manager'),
        titleTextStyle: TextStyle(color:Colors.white,fontWeight: FontWeight.bold
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(index.toString()),
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
                        // Display task text without leading "[ ]"
                        filteredTasks[index].substring(3),
                        style: TextStyle(
                          fontSize: 18.0,
                          decoration: filteredTasks[index].startsWith('[X]')
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        // Directly use task state to determine checkbox value
                        value: filteredTasks[index].startsWith('[X]'), // Change here
                        onChanged: (_) => _toggleTask(index),
                      ),
                      tileColor: Colors.grey[200], // Background color for each task
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final TextEditingController textController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add New Task'),
              content: TextField(
                controller: textController, // Assign controller to TextField
                decoration: InputDecoration(
                  hintText: 'Enter a task',
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    _addTask(textController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
