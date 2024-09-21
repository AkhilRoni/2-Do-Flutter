import 'package:flutter/material.dart';
import 'package:tudo/config/colors.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: lightbg,
        primary: lightpr,
        secondary: lightse,
        tertiary: Colors.black),
    iconTheme: const IconThemeData(color: Colors.black));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: darkbg,
        primary: darkpr,
        secondary: darkse,
        tertiary: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white));
