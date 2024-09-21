// ignore_for_file: camel_case_types, library_private_types_in_public_api

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tudo/config/theme_provider.dart";
import "package:tudo/main.dart";
import '../model/todo.dart'; // Adjust the path to your model
import "package:tudo/screens/timer.dart";
import "package:provider/provider.dart";
import "package:tudo/screens/tasks.dart";
import 'package:tudo/config/phrases.dart';
import 'dart:math';

class tt extends StatefulWidget {
  final List<ToDo> todosList;

  const tt({super.key, required this.todosList});

  @override
  _ttState createState() => _ttState();
}

class _ttState extends State<tt> {
  String currentPhrase = getPhrase(); // Initial quote

  void openDrawer(BuildContext context) {
    setState(() {
      currentPhrase = getPhrase(); // Update the quote
    });
    Scaffold.of(context).openDrawer(); // Open the drawer
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_rounded, size: 35),
            padding: const EdgeInsets.only(left: 10),
            onPressed: () => openDrawer(context),
          );
        }),
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Schedule',
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
            backgroundColor: Theme.of(context).colorScheme.background,
            fontSize: 35),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => homepage(todosList: widget.todosList)));
            },
            icon: const Icon(CupertinoIcons.home, size: 35),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: ListView(
            children: [
              Container(height: 50),
              ListTile(
                title: const Text('  Tasks',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: isDarkMode
              ? Image.asset('images/ttdark.png')
              : Image.asset('images/ttlight.png'),
        ),
      ),
    );
  }
}

String getPhrase() {
  final random = Random();
  return phrases[random.nextInt(phrases.length)];
}
