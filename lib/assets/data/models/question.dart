class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String category;
  final String difficulty;
  final String funFact;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.category,
    required this.difficulty,
    required this.funFact,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correctAnswer'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      funFact: json['funFact'] as String,
    );
  }
}
