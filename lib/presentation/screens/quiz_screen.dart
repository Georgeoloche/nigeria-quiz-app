import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/question.dart';
import '../../assets/data/repositories/question_repository_impl.dart';
import '../../assets/data/sources/question_local_data_source.dart';

class QuizScreen extends StatefulWidget {
  final String selectedCategory;
  final String selectedDifficulty;

  const QuizScreen({
    super.key,
    required this.selectedCategory,
    required this.selectedDifficulty,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuestionRepositoryImpl repository =
      QuestionRepositoryImpl(localDataSource: QuestionLocalDataSource());

  List<Question> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  int _score = 0;
  bool _quizCompleted = false;
  int _timeLeft = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    List<Question> loadedQuestions = await repository.getQuestions(
      category: widget.selectedCategory,
      difficulty: widget.selectedDifficulty,
    );

    // Optional: shuffle options
    // for (var q in loadedQuestions) {
    //   q.options.shuffle();
    // }

    if (mounted) {
      setState(() {
        _questions = loadedQuestions;
      });

      if (_questions.isNotEmpty) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 10;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _moveToNextQuestion();
        }
      });
    });
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null || _quizCompleted) return;

    setState(() {
      _selectedAnswer = answer;
    });

    _timer?.cancel();

    bool isCorrect = answer == _questions[_currentIndex].answer;

    if (isCorrect) {
      _score++;
    }

    Future.delayed(const Duration(seconds: 1), _moveToNextQuestion);
  }

  void _moveToNextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });

      _startTimer();
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _score = 0;
      _quizCompleted = false;
    });

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_quizCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz Completed!")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎉 Quiz Completed!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Your Score: $_score / ${_questions.length}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _restartQuiz,
                child: const Text("Restart Quiz"),
              ),
            ],
          ),
        ),
      );
    }

    Question currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Nigeria Trivia")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${_currentIndex + 1} of ${_questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ).animate().fade(duration: 500.ms),

            const SizedBox(height: 10),

            Text(
              "Score: $_score",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ).animate().scale(),

            const SizedBox(height: 10),

            Text(
              "Time Left: $_timeLeft seconds",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ).animate().slideX(),

            const SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentQuestion.question,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ).animate().fade(duration: 500.ms),

            const SizedBox(height: 20),

            /// ✅ THIS IS THE FIX
            ...currentQuestion.options
                .map((option) => _buildAnswerButton(option))
                ,
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () => _selectAnswer(answer),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedAnswer == answer
              ? (_selectedAnswer ==
                      _questions[_currentIndex].answer
                  ? Colors.green
                  : Colors.red)
              : Colors.blue,
        ),
        child: Text(answer),
      ).animate().scale(),
    );
  }
}