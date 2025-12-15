import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Countries Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizHomePage(),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.country,
    required this.options,
    required this.correctIndex,
    this.fact,
  });

  final String country;
  final List<String> options;
  final int correctIndex;
  final String? fact;
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      country: 'Canada',
      options: ['Ottawa', 'Toronto', 'Vancouver', 'Montreal'],
      correctIndex: 0,
      fact: 'Ottawa sits on the Ontario–Quebec border and is home to the Rideau Canal.',
    ),
    QuizQuestion(
      country: 'Japan',
      options: ['Kyoto', 'Tokyo', 'Osaka', 'Sapporo'],
      correctIndex: 1,
      fact: 'Tokyo is the world’s most populous metropolitan area.',
    ),
    QuizQuestion(
      country: 'Australia',
      options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'],
      correctIndex: 2,
      fact: 'Canberra was selected as a compromise between rivals Sydney and Melbourne.',
    ),
    QuizQuestion(
      country: 'Brazil',
      options: ['São Paulo', 'Brasília', 'Rio de Janeiro', 'Salvador'],
      correctIndex: 1,
      fact: 'Brasília was inaugurated in 1960 and designed by architect Oscar Niemeyer.',
    ),
    QuizQuestion(
      country: 'Kenya',
      options: ['Mombasa', 'Nairobi', 'Kisumu', 'Nakuru'],
      correctIndex: 1,
      fact: 'Nairobi is nicknamed "The Green City in the Sun" for its parks and sunshine.',
    ),
    QuizQuestion(
      country: 'Germany',
      options: ['Hamburg', 'Berlin', 'Munich', 'Frankfurt'],
      correctIndex: 1,
      fact: 'Berlin has more bridges than Venice and is nine times larger.',
    ),
    QuizQuestion(
      country: 'Argentina',
      options: ['Córdoba', 'Buenos Aires', 'Rosario', 'Mendoza'],
      correctIndex: 1,
      fact: 'Buenos Aires is called the "Paris of South America" for its architecture.',
    ),
    QuizQuestion(
      country: 'Egypt',
      options: ['Giza', 'Alexandria', 'Cairo', 'Luxor'],
      correctIndex: 2,
      fact: 'Cairo’s metropolitan area is the largest in the Arab world.',
    ),
    QuizQuestion(
      country: 'Norway',
      options: ['Bergen', 'Trondheim', 'Oslo', 'Stavanger'],
      correctIndex: 2,
      fact: 'Oslo is surrounded by the Oslofjord and forested hills, making it great for hiking.',
    ),
    QuizQuestion(
      country: 'Thailand',
      options: ['Chiang Mai', 'Bangkok', 'Phuket', 'Pattaya'],
      correctIndex: 1,
      fact: 'Bangkok’s ceremonial name is over 160 characters long in Thai.',
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _showSummary = false;

  QuizQuestion get _currentQuestion => _questions[_currentIndex];

  void _selectOption(int index) {
    if (_showSummary) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _nextQuestion() {
    if (_selectedIndex == null) {
      return;
    }

    setState(() {
      if (_selectedIndex == _currentQuestion.correctIndex) {
        _score += 1;
      }

      if (_currentIndex < _questions.length - 1) {
        _currentIndex += 1;
        _selectedIndex = null;
      } else {
        _showSummary = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedIndex = null;
      _showSummary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _showSummary
        ? 1.0
        : (_currentIndex + 1) / _questions.length.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Countries Quiz'),
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
                      _showSummary
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
                  child: _showSummary ? _buildSummaryCard() : _buildQuestionCard(),
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
              final isSelected = _selectedIndex == index;
              final isCorrect = _currentQuestion.correctIndex == index;
              final answered = _selectedIndex != null;

              Color? background;
              Color? foreground;
              if (answered && isSelected) {
                background = isCorrect
                    ? Colors.green.shade100
                    : Colors.red.shade100;
                foreground = isCorrect ? Colors.green.shade800 : Colors.red;
              } else if (answered && isCorrect) {
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
                        isCorrect
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: answered
                            ? (isCorrect ? Colors.green : Colors.red)
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
            if (_selectedIndex != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    _selectedIndex == _currentQuestion.correctIndex
                        ? Icons.emoji_events
                        : Icons.travel_explore,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedIndex == _currentQuestion.correctIndex
                          ? 'Great! That\'s correct.'
                          : 'Not quite. The capital is ${_currentQuestion.options[_currentQuestion.correctIndex]}.',
                    ),
                  ),
                ],
              ),
              if (_currentQuestion.fact != null) ...[
                const SizedBox(height: 8),
                Text(
                  _currentQuestion.fact!,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
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
            onPressed:
                _selectedIndex == null && !_showSummary ? null : _nextQuestion,
            icon: Icon(_showSummary ? Icons.check : Icons.arrow_forward),
            label: Text(_showSummary ? 'View score' : 'Next question'),
          ),
        ),
      ],
    );
  }
}
