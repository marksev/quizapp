import 'dart:math';

import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'models/question.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries & Capitals Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizHomePage(),
    );
  }
}

enum QuizStage { notStarted, inProgress, finished }

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final Random _random = Random();
  List<Question> _questions = [];
  QuizStage _stage = QuizStage.notStarted;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;

  Question get _currentQuestion => _questions[_currentIndex];

  bool get _hasAnswered => _selectedIndex != null;

  List<Question> _generateShuffledQuestions() {
    final shuffledQuestions = List<Question>.from(questions)
      ..shuffle(_random);

    return shuffledQuestions
        .map(
          (question) => Question(
            country: question.country,
            options: (List<String>.from(question.options)..shuffle(_random)),
            correctAnswer: question.correctAnswer,
          ),
        )
        .toList();
  }

  void _selectOption(int index) {
    if (_stage != QuizStage.inProgress || _hasAnswered) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _nextQuestion() {
    if (!_hasAnswered) {
      return;
    }

    final bool isCorrect =
        _currentQuestion.options[_selectedIndex!] == _currentQuestion.correctAnswer;

    setState(() {
      if (isCorrect) {
        _score += 1;
      }

      if (_currentIndex < _questions.length - 1) {
        _currentIndex += 1;
        _selectedIndex = null;
      } else {
        _stage = QuizStage.finished;
        _selectedIndex = null;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _stage = QuizStage.notStarted;
      _currentIndex = 0;
      _score = 0;
      _selectedIndex = null;
      _questions = [];
    });
  }

  void _startQuiz() {
    setState(() {
      _questions = _generateShuffledQuestions();
      _stage = QuizStage.inProgress;
      _currentIndex = 0;
      _score = 0;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = switch (_stage) {
      QuizStage.notStarted => 0.0,
      QuizStage.inProgress =>
          (_currentIndex + 1) / _questions.length.toDouble(),
      QuizStage.finished => 1.0,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries & Capitals Quiz'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _stage == QuizStage.notStarted
                          ? 'Welcome'
                          : _stage == QuizStage.finished
                              ? 'Completed'
                              : 'Question ${_currentIndex + 1} of ${_questions.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Chip(
                      label: Text('Score: $_score'),
                      avatar: const Icon(Icons.star, color: Colors.amber),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: switch (_stage) {
                    QuizStage.notStarted => _buildStartCard(),
                    QuizStage.finished => _buildSummaryCard(),
                    QuizStage.inProgress => _buildQuestionCard(),
                  },
                ),
                const SizedBox(height: 16),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 16),
            Text(
              'Countries & Capitals',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Test your knowledge of world capitals. Each question has four options—choose wisely!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _startQuiz,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.shade50,
                  ),
                  child: const Icon(Icons.public, color: Colors.deepPurple),
                ),
                const SizedBox(width: 12),
                Text(
                  _currentQuestion.country,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Which city is the capital of ${_currentQuestion.country}?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...List.generate(_currentQuestion.options.length, (index) {
              final option = _currentQuestion.options[index];
              final bool isSelected = _selectedIndex == index;
              final bool isCorrectOption =
                  option == _currentQuestion.correctAnswer;
              final bool answered = _hasAnswered;

              Color? background;
              Color? foreground;
              if (answered && isSelected) {
                background =
                    isCorrectOption ? Colors.green.shade100 : Colors.red.shade100;
                foreground =
                    isCorrectOption ? Colors.green.shade800 : Colors.red.shade800;
              } else if (answered && isCorrectOption) {
                background = Colors.green.shade50;
                foreground = Colors.green.shade800;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: answered ? null : () => _selectOption(index),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    backgroundColor: background,
                    foregroundColor: foreground,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        !answered
                            ? Icons.radio_button_unchecked
                            : isCorrectOption
                                ? Icons.check_circle
                                : isSelected
                                    ? Icons.cancel
                                    : Icons.radio_button_unchecked,
                        color: !answered
                            ? Colors.grey
                            : isCorrectOption
                                ? Colors.green
                                : isSelected
                                    ? Colors.red
                                    : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (_hasAnswered) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    _currentQuestion.options[_selectedIndex!] ==
                            _currentQuestion.correctAnswer
                        ? Icons.emoji_events
                        : Icons.travel_explore,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentQuestion.options[_selectedIndex!] ==
                              _currentQuestion.correctAnswer
                          ? 'Great! That\'s correct.'
                          : 'Not quite. The capital is ${_currentQuestion.correctAnswer}.',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 16),
            Text(
              'Quiz complete!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $_score out of ${_questions.length}.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              _score == _questions.length
                  ? 'A perfect score! You really know your world capitals.'
                  : 'Keep exploring the globe and try again to improve your score.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    if (_stage == QuizStage.notStarted) {
      return const SizedBox.shrink();
    }

    if (_stage == QuizStage.finished) {
      return FilledButton.icon(
        onPressed: _restartQuiz,
        icon: const Icon(Icons.refresh),
        label: const Text('Restart Quiz'),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _restartQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _hasAnswered ? _nextQuestion : null,
            icon: Icon(
              _currentIndex == _questions.length - 1
                  ? Icons.check
                  : Icons.arrow_forward,
            ),
            label: Text(
              _currentIndex == _questions.length - 1
                  ? 'Finish Quiz'
                  : 'Next Question',
            ),
          ),
        ),
      ],
    );
  }
}
