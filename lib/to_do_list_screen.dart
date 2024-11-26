import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login_screen.dart';

class ToDoListScreen extends StatefulWidget {
  final String username; // Pass the username to associate the data
  const ToDoListScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<String> _toDoItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList(); // Load the list when the screen initializes
  }

  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getString('${widget.username}_toDoList'); // Unique key for each user
    if (savedList != null) {
      setState(() {
        _toDoItems = List<String>.from(jsonDecode(savedList));
      });
    }
  }

  Future<void> _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${widget.username}_toDoList', jsonEncode(_toDoItems));
  }

  void _addToDoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _toDoItems.add(task);
      });
      _controller.clear();
      _saveToDoList(); // Save the updated list
    }
  }

  void _deleteToDoItem(int index) {
    setState(() {
      _toDoItems.removeAt(index);
    });
    _saveToDoList(); // Save the updated list
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do List',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                hintText: 'Add a new task...',
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _addToDoItem(_controller.text),
                ),
              ),
              onSubmitted: _addToDoItem,
            ),
          ),
          Expanded(
            child: _toDoItems.isEmpty
                ? const Center(
              child: Text(
                'No tasks yet! Add some...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            )
                : ListView.builder(
              itemCount: _toDoItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Card(
                    color: const Color(0xFF1E1E1E),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        _toDoItems[index],
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () => _deleteToDoItem(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
