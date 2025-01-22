import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black,
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: Colors.black,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Voice Assistant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement conversation start logic
          },
          child: const Text(
            'Start Conversation',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
