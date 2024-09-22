// ignore_for_file: unused_field, camel_case_types, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudo/api/firebase_api.dart';
import 'package:tudo/config/theme_provider.dart';
import 'package:tudo/screens/option_box.dart';
import 'package:tudo/screens/tasks.dart';
import '../model/todo.dart';
import 'config/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tudo/screens/tt.dart';
import 'package:lottie/lottie.dart';
import 'package:tudo/screens/timer.dart';
import 'package:tudo/config/time_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) => TimeProvider()), // Add TimeProvider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // final primarySwatch = MaterialColor(
    //   tdBGColor.value,
    //   <int, Color>{
    //     50: tdBGColor.withOpacity(0.1),
    //     100: tdBGColor.withOpacity(0.2),
    //     200: tdBGColor.withOpacity(0.3),
    //     300: tdBGColor.withOpacity(0.4),
    //     400: tdBGColor.withOpacity(0.5),
    //     500: tdBGColor.withOpacity(0.6),
    //     600: tdBGColor.withOpacity(0.7),
    //     700: tdBGColor.withOpacity(0.8),
    //     800: tdBGColor.withOpacity(0.9),
    //     900: tdBGColor.withOpacity(1.0),
    //   },
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => homepage(todosList: todosList);
      // },
    );
  }
}

// SPLASH SCREEN CLASS

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  List<ToDo> todosList = []; // Define the todosList here
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    initializeApp();
    _playAnimation();
  }

  Future<void> initializeApp() async {
    await fetchTasks();
    await _controller.forward();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => homepage(todosList: todosList),
      ),
    );
  }

  void _playAnimation() {
    _controller.forward().then((_) {
      _controller.value = 1.0;
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  Future<void> fetchTasks() async {
    final tasks = await FirebaseService.fetchTasksFromFirebase();
    setState(() {
      todosList = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        body: Center(
            child: Lottie.asset('assets/logoanime.json',
                height: 300, controller: _controller, onLoaded: (composition) {
          _controller.duration = composition.duration;
        })));
  }
}

// HOME PAGE CLASS

class homepage extends StatefulWidget {
  final List<ToDo> todosList; // Accept todosList as a parameter
  const homepage({super.key, required this.todosList});

  @override
  State<homepage> createState() => _homepageState();
}

// ignore: camel_case_types
class _homepageState extends State<homepage> with TickerProviderStateMixin {
  late List myoptions;
  late bool isDarkMode;
  late AnimationController _controller;
  //late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    myoptions = [
      //[option name, icon path, screen path]
      ["Tasks", "lib/icons/tasks.png", RootPage(todosList: widget.todosList)],
      ["Timer", "lib/icons/timer.png", timer(todosList: widget.todosList)],
      ["Schedule", "lib/icons/tt.png", tt(todosList: widget.todosList)],
      //isDarkMode: isDarkMode

      ["Theme", "lib/icons/mode.png", RootPage(todosList: widget.todosList)],
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // _animation = Tween<double>(begin: 250.0, end: 481.0)
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _setLottieFrame();
  }

  //Animation controller for lottie

  //Function to set frame
  void _setLottieFrame() {
    if (isDarkMode) {
      _controller.value = 270 / 481;
    } else {
      _controller.value = 429 / 481;
    }
  }

  //Function to animate frame
  void _toggleFrame() {
    setState(() {
      isDarkMode = !isDarkMode;
    });

    if (isDarkMode) {
      _controller.animateTo(270 / 481,
          duration: const Duration(milliseconds: 800));
    } else {
      _controller.animateTo(429 / 481,
          duration: const Duration(milliseconds: 800));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      // Update animation based on current theme

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              // LOTTIE ANIMATION

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Lottie.asset('assets/mode.json',
                    controller: _controller,
                    height: 175,
                    frameRate: const FrameRate(60)),
              ),
              // HOMEPAGE TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to Your Dashboard',
                        style: TextStyle(fontSize: 20)),
                    Text(
                      'Choose your Path',
                      style: TextStyle(fontSize: 40),
                    )
                  ],
                ),
              ),

              //GRID VIEW
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1 / 1.2),
                  itemCount: 4,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return OptionBox(
                      optionName: myoptions[index][0],
                      iconPath: myoptions[index][1],
                      screenPath: myoptions[index][2],
                      toggleFrame: index == 3 ? _toggleFrame : () {},
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               RootPage(todosList: widget.todosList)));
//                 },
//                 child: Text('Tasks'))
