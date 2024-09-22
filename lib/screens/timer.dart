// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import "package:tudo/config/theme_provider.dart";
import 'package:tudo/config/time_provider.dart';
import '../model/todo.dart';
import "package:tudo/screens/tasks.dart";
import "package:tudo/screens/tt.dart";
import "package:tudo/main.dart";
import 'package:tudo/config/phrases.dart';
import 'dart:math';

class timer extends StatefulWidget {
  final List<ToDo> todosList;
  final List<List> tones = [
    [' Simple ', '../assets/sounds/simple.mp3'],
    [' Happy ', '../assets/sounds/happy.wav'],
    [' K-pop ', '../assets/sounds/kpop.mp3'],
    [' Bravo ', '../assets/sounds/bravo.wav'],
    [' Ding ', '../assets/sounds/ding.wav'],
    [' Meow ', '../assets/sounds/meow.wav'],
  ];

  timer({super.key, required this.todosList});

  @override
  State<timer> createState() => _timerState();
}

class _timerState extends State<timer> {
  String currentPhrase = getPhrase();
  int currentToneIndex = 0;

  void openDrawer(BuildContext context) {
    setState(() {
      currentPhrase = getPhrase();
    });

    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final timeprovider = Provider.of<TimeProvider>(context);

    return Consumer<TimeProvider>(builder: (context, timeProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(builder: (context) {
            return IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 35,
                ),
                padding: const EdgeInsets.only(left: 10),
                onPressed: () => openDrawer(context));
          }),
          foregroundColor: Theme.of(context).colorScheme.tertiary,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Timer',
            style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          titleTextStyle: TextStyle(
              backgroundColor: Theme.of(context).colorScheme.background,
              // color: Colors.black,
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
        body: Center(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 35)),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      color: Theme.of(context).colorScheme.tertiary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      value: timeprovider.remainingTime > 0
                          ? timeprovider.remainingTime /
                              timeprovider.initialTime
                          : 0,
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  Text(
                    _formatTime(timeprovider.remainingTime),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 50),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              // STOP AND PLAY BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      timeprovider.resetTimer();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        fixedSize: const Size(100, 100),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      Icons.stop,
                      size: 75,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Container(
                    width: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        timeprovider.isRunning
                            ? timeprovider.pauseTimer()
                            : timeprovider.startTimer(currentToneIndex);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fixedSize: const Size(100, 100),
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.center,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: timeprovider.isRunning
                          ? Icon(
                              Icons.pause,
                              size: 80,
                              color: Theme.of(context).iconTheme.color,
                            )
                          : Icon(
                              Icons.play_arrow,
                              size: 80,
                              color: Theme.of(context).iconTheme.color,
                            ))
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              //STUDY AND BREAKK TIMER BUTTONS

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      timeprovider.breakTimer();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(' Break(5) ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Theme.of(context).colorScheme.tertiary)),
                  ),
                  Container(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        timeprovider.studyTimer();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(' Study(25) ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Theme.of(context).colorScheme.tertiary)))
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              //CUSTOM BUTTON

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _showTimePicker(context, timeprovider);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(' Custom ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Theme.of(context).colorScheme.tertiary))),
                  Container(
                    width: 15,
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Icon(
                      Icons.music_note_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 40,
                    ),
                  ),
                  Container(
                    width: 2,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentToneIndex =
                              ((currentToneIndex + 1) % widget.tones.length)
                                  .toInt();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(
                          widget.tones[currentToneIndex]
                              [0], // Get tone name from list
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Theme.of(context).colorScheme.tertiary,
                          ))),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  void _showTimePicker(BuildContext context, TimeProvider timeProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: Duration(seconds: timeProvider.remainingTime),
            onTimerDurationChanged: (Duration newDuration) {
              if (newDuration.inSeconds > 0) {
                timeProvider.setTimer(newDuration.inSeconds);
              }
            },
          ),
        );
      },
    );
  }
}

String _formatTime(int totalSeconds) {
  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

String getPhrase() {
  final random = Random();
  return phrases[random.nextInt(phrases.length)];
}
