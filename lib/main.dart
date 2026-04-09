import 'package:flutter/material.dart';
import 'package:nigeria_trivia/presentation/screens/category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON into the database.
  await DatabaseHelper.instance.loadJsonIntoDatabase(await DatabaseHelper.instance.database);
  runApp(const MyApp());
}

class DatabaseHelper {
  static get instance => null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nigeria Trivia',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CategoryScreen(), // Launches the category selection screen
    );
  }
}
