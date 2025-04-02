import 'dart:async';

import 'package:flutter/material.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<bool?> _answers = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _timeLeft = 30; // 30 seconds per question
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['London', 'Paris', 'Berlin', 'Madrid'],
      'correctIndex': 1,
      'explanation': 'Paris has been the capital of France since 508 AD.'
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correctIndex': 1,
      'explanation': 'Mars appears red due to iron oxide on its surface.'
    },
    // Add more questions...
  ];

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, null);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer.cancel();
        _answerQuestion(-1); // -1 indicates time expired
      }
    });
  }

  void _resetTimer() {
    _timer.cancel();
    _timeLeft = 30;
    _startTimer();
  }

  void _answerQuestion(int selectedIndex) {
    _timer.cancel();
    
    setState(() {
      _answers[_currentQuestionIndex] = 
          selectedIndex == _questions[_currentQuestionIndex]['correctIndex'];
      
      if (_answers[_currentQuestionIndex] == true) {
        _score++;
      }
    });

    _animationController.forward().then((_) {
      if (_currentQuestionIndex < _questions.length - 1) {
        _animationController.reset();
        setState(() {
          _currentQuestionIndex++;
          _resetTimer();
        });
        _animationController.forward();
      } else {
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultsScreen(
          score: _score,
          totalQuestions: _questions.length,
          quiz: widget.quiz,
          answers: _answers,
          questions: _questions,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz['title']),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: _timeLeft / 30,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  _timeLeft > 10 ? Colors.blue : Colors.red,
                ),
              ),
              Text(
                '$_timeLeft',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _timeLeft > 10 ? Colors.black : Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.grey[200],
                minHeight: 8,
              ),
              SizedBox(height: 20),
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                currentQuestion['question'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestion['options'].length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => _answerQuestion(index),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(currentQuestion['options'][index]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}