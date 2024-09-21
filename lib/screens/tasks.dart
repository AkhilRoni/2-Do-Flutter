import "package:flutter/material.dart";
import '../model/todo.dart'; // Adjust the path to your model
import '../widgets/todo_item.dart';
import '../config/colors.dart';
import '../api/firebase_api.dart';
import "package:tudo/screens/timer.dart";
import "package:tudo/screens/tt.dart";
import "package:flutter/cupertino.dart";
import 'package:tudo/main.dart';
import 'package:tudo/config/phrases.dart';
import 'dart:math';

class RootPage extends StatefulWidget {
  final List<ToDo> todosList;

  // ignore: use_super_parameters
  const RootPage({Key? key, required this.todosList}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _todoController = TextEditingController();

  String currentPhrase = getPhrase(); // Initial quote

  void openDrawer(BuildContext context) {
    setState(() {
      currentPhrase = getPhrase(); // Update the quote
    });
    Scaffold.of(context).openDrawer(); // Open the drawer
  }

  // List<ToDo> todosList = [];

  //@override
  // void initState() {
  //   super.initState();
  //   fetchTasks();
  // }

  // Future<void> fetchTasks() async {
  //   final tasks = await FirebaseService.fetchTasksFromFirebase();
  //   setState(() {
  //     todosList = tasks;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_rounded, size: 40),
            padding: const EdgeInsets.only(left: 10),
            onPressed: () => openDrawer(context),
          );
        }),
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Tasks',
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
            backgroundColor: Theme.of(context).colorScheme.background,
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 35),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        homepage(todosList: widget.todosList)));
              },
              icon: const Icon(CupertinoIcons.home, size: 35)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: ListView(
            children: [
              Container(
                height: 50,
              ),
              ListTile(
                title: const Text(
                  '  Tasks',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RootPage(todosList: widget.todosList)));
                },
              ),
              ListTile(
                title: const Text('  Timer',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              timer(todosList: widget.todosList)));
                },
              ),
              ListTile(
                title: const Text('  Schedule',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              tt(todosList: widget.todosList)));
                },
              ),
              const SizedBox(height: 380),
              ListTile(
                title:
                    Text(currentPhrase, style: const TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 15),
                        child: Text(
                          'We have ${widget.todosList.length} tasks remaining',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                      for (ToDo todoo in widget.todosList)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 69),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: tdGrey,
                            offset: Offset(0, 0),
                            spreadRadius: 0),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: 'Add a new Task',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54)),
                    style: const TextStyle(color: Colors.black),
                  ),
                )),
                Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton(
                          onPressed: () {
                            _addToDoItem(_todoController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(60, 60),
                            elevation: 0,
                          ),
                          child: Text('+',
                              style: TextStyle(
                                  fontSize: 40,
                                  color:
                                      Theme.of(context).colorScheme.tertiary))),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    final newIsDone = !todo.isDone;
    setState(() {
      todo.isDone = newIsDone;
    });
    FirebaseService.updateisDone(todo.id, newIsDone);
  }

  void _deleteToDoItem(String id) {
    setState(() {
      widget.todosList.removeWhere((item) => item.id == id);
    });
    FirebaseService.deletefromFirebase(id);
  }

  void _addToDoItem(String toDo) {
    if (toDo.isNotEmpty) {
      setState(() {
        final newtask = ToDo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            todoText: toDo);
        widget.todosList.add(newtask);
        FirebaseService.addtask(newtask);
      });
    }
    _todoController.clear();
  }
}

String getPhrase() {
  final random = Random();
  return phrases[random.nextInt(phrases.length)];
}
