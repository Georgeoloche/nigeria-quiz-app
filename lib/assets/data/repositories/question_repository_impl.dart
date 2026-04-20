import 'package:nigeria_trivia/assets/data/models/question_model.dart';
import 'package:nigeria_trivia/assets/data/sources/question_local_data_source.dart';
import 'package:nigeria_trivia/domain/Repositories/question_repository.dart';

import '../../../domain/entities/question.dart';


class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionLocalDataSource localDataSource;
  QuestionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Question>> getQuestions({required String category, required String difficulty}) async {
    List<QuestionModel> questions = await localDataSource.loadQuestions();
    // Filter by category and difficulty.
    return questions.where((q) => q.category == category && q.difficulty == difficulty).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    List<QuestionModel> questions = await localDataSource.loadQuestions();
    return questions.map((q) => q.category).toSet().toList();
  }
}
