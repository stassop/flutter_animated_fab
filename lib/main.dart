import 'package:flutter/material.dart';
import 'package:flutter_animated_fab/animated_fab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated FAB',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MyHomePage(
        isDarkMode: isDarkMode,
        toggleDarkMode: toggleDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    required this.isDarkMode,
    required this.toggleDarkMode,
  }) : super(key: key);

  final bool isDarkMode;
  final Function() toggleDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated FAB'),
      ),
      body: Center(
        child: Text(
          isDarkMode ? 'Dark mode' : 'Light mode',
        ),
      ),
      floatingActionButton: AnimatedFAB(
        onPressed: toggleDarkMode,
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        child: isDarkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
      ),
    );
  }
}
