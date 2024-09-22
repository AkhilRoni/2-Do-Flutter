import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

class TimeProvider extends ChangeNotifier {
  List<List> tones = [
    [' Simple ', '../assets/sounds/simple.mp3'],
    [' Happy ', '../assets/sounds/happy.wav'],
    [' K-pop ', '../assets/sounds/kpop.mp3'],
    [' Bravo ', '../assets/sounds/bravo.wav'],
    [' Ding ', '../assets/sounds/ding.wav'],
    [' Meow ', '../assets/sounds/meow.wav'],
  ];

  int _remainingTime = 1500;
  int _initialTime = 1500;
  Timer? _timer;
  bool _isRunning = false;

  int get remainingTime => _remainingTime;
  int get initialTime => _initialTime;
  bool get isRunning => _isRunning;

  AudioPlayer audioPlayer = AudioPlayer();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void startTimer(int currentIndex) async {
    if (_timer != null || _remainingTime == 0) return;

    _isRunning = true;
    _remainingTime--;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _timer = null;
        _remainingTime = _initialTime;
        _isRunning = false;
        notifyListeners();
        await showNotification();
        await audioPlayer.play(AssetSource(tones[currentIndex][1]));
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _remainingTime = _initialTime;
    _isRunning = false;
    notifyListeners();
  }

  void setTimer(int seconds) {
    _remainingTime = seconds;
    _initialTime = seconds;
    notifyListeners();
  }

  void studyTimer() {
    _remainingTime = 1500;
    _initialTime = 1500;
    notifyListeners();
  }

  void breakTimer() {
    _remainingTime = 300;
    _initialTime = 300;
    notifyListeners();
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channelId1', 'TimerOver');

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Timer Done!', // Title
      'Your timer has completed.', // Body
      notificationDetails,
    );
  }
}
