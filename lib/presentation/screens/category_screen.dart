import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  // For now, we use a fixed list. You can later make this dynamic if needed.
  final List<String> categories = const ["History", "Geography", "Culture", "Economy", "General Knowledge"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Category")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          return ListTile(
            title: Text(category),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // For now, default difficulty is 'easy'. You can later implement a separate difficulty selection.
              Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(selectedCategory: category, selectedDifficulty: "easy")));
            },
          );
        },
      ),
    );
  }
}
