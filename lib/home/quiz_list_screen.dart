import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/quiz_card.dart';
import '../screens/quiz/quiz_screen.dart';

class QuizListScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final IconData categoryIcon;

   QuizListScreen({
    Key? key,
    required this.categoryName,
    required this.categoryColor,
    this.categoryIcon = Icons.quiz,
  }) : super(key: key);

  final List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Basic Concepts',
      'questions': 12,
      'difficulty': 'Easy',
      'duration': '10 mins',
      'completion': 0.7,
      'heroTag': 'quiz1',
      'questionList': [
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
      ]
    },
    {
      'title': 'Intermediate Theories',
      'questions': 18,
      'difficulty': 'Medium',
      'duration': '15 mins',
      'completion': 0.4,
      'heroTag': 'quiz2',
      'questionList': [
        {
          'question': 'What is the largest ocean on Earth?',
          'options': ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
          'correctIndex': 3,
          'explanation': 'The Pacific Ocean covers about 63 million square miles.'
        },
      ]
    },
    {
      'title': 'Advanced Applications',
      'questions': 24,
      'difficulty': 'Hard',
      'duration': '25 mins',
      'completion': 0.1,
      'heroTag': 'quiz3',
      'questionList': [
        {
          'question': 'Which element has the atomic number 79?',
          'options': ['Silver', 'Gold', 'Platinum', 'Mercury'],
          'correctIndex': 1,
          'explanation': 'Gold (Au) has atomic number 79 on the periodic table.'
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                categoryName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.5),
                      categoryColor.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    categoryIcon,
                    size: 60,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    _buildFilterChip('Easy', false),
                    _buildFilterChip('Medium', false),
                    _buildFilterChip('Hard', false),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Hero(
                  tag: quizzes[index]['heroTag'],
                  child: QuizCard(
                    title: quizzes[index]['title'],
                    questionCount: quizzes[index]['questions'],
                    duration: quizzes[index]['duration'],
                    difficulty: quizzes[index]['difficulty'],
                    completion: quizzes[index]['completion'],
                    accentColor: categoryColor,
                    onTap: () => _navigateToQuiz(context, quizzes[index]),
                  ),
                ),
                childCount: quizzes.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (quizzes.isNotEmpty) {
            _navigateToQuiz(context, quizzes[0]); // Start first quiz
          }
        },
        backgroundColor: categoryColor,
        icon: Icon(Iconsax.flash),
        label: Text('Quick Quiz'),
        elevation: 4,
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool value) {
          // Add filter logic here
        },
        selectedColor: categoryColor.withOpacity(0.2),
        checkmarkColor: categoryColor,
        labelStyle: TextStyle(
          color: selected ? categoryColor : Colors.grey,
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context, Map<String, dynamic> quiz) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => QuizScreen(
          quiz: quiz,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}