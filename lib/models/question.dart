class Question {
  const Question({
    required this.country,
    required this.options,
    required this.correctAnswer,
  });

  final String country;
  final List<String> options;
  final String correctAnswer;
}
