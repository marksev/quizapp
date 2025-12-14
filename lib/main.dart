import 'package:flutter/material.dart';

void main() {
  runApp(const CapitalsQuizApp());
}

class CapitalsQuizApp extends StatelessWidget {
  const CapitalsQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capitals Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.country,
    required this.capitals,
    required this.answerIndex,
  });

  final String country;
  final List<String> capitals;
  final int answerIndex;
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      country: 'Canada',
      capitals: ['Ottawa', 'Toronto', 'Vancouver', 'Montreal'],
      answerIndex: 0,
    ),
    QuizQuestion(
      country: 'France',
      capitals: ['Madrid', 'Paris', 'Lisbon', 'Vienna'],
      answerIndex: 1,
    ),
    QuizQuestion(
      country: 'Italy',
      capitals: ['Rome', 'Milan', 'Naples', 'Florence'],
      answerIndex: 0,
    ),
    QuizQuestion(
      country: 'Spain',
      capitals: ['Barcelona', 'Madrid', 'Seville', 'Valencia'],
      answerIndex: 1,
    ),
    QuizQuestion(
      country: 'United States',
      capitals: ['New York City', 'Washington, D.C.', 'Los Angeles', 'Chicago'],
      answerIndex: 1,
    ),
  ];

  List<int?> _selectedAnswers =
      List<int?>.filled(_questions.length, null, growable: false);
  int _currentQuestion = 0;
  bool _showResults = false;

  int get _score {
    int total = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].answerIndex) {
        total++;
      }
    }
    return total;
  }

  void _selectAnswer(int index) {
    final bool lastQuestion = _currentQuestion == _questions.length - 1;
    setState(() {
      _selectedAnswers[_currentQuestion] = index;
      if (lastQuestion) {
        _showResults = true;
      } else {
        _currentQuestion++;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _selectedAnswers = List<int?>.filled(_questions.length, null);
      _currentQuestion = 0;
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Capitals Quiz'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _showResults ? _buildResults(context) : _buildQuestion(),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final QuizQuestion question = _questions[_currentQuestion];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${_currentQuestion + 1} of ${_questions.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: (_currentQuestion + 1) / _questions.length,
        ),
        const SizedBox(height: 24),
        Text(
          'What is the capital of ${question.country}?',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(question.capitals.length, (index) {
          final bool isSelected = _selectedAnswers[_currentQuestion] == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _selectAnswer(index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.capitals[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    final int totalQuestions = _questions.length;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'You got $_score out of $totalQuestions correct',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Great job exploring world capitals!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: _restartQuiz,
              child: const Text('Restart quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
