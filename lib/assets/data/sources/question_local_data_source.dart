import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuestionLocalDataSource {
  Future<List<QuestionModel>> loadQuestions() async {
    final String jsonString = await rootBundle.loadString('assets/nigeria_trivia_questions.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> questionsJson = jsonMap['questions'];
    return questionsJson.map((q) => QuestionModel.fromJson(q)).toList();
  }
}
