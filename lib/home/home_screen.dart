import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'categories_screen.dart';
import 'widgets/category_card.dart';
import 'widgets/quiz_card.dart';
import 'quiz_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Science', 'icon': Icons.science, 'color': Colors.blue, 'progress': 0.75},
    {'name': 'Math', 'icon': Icons.calculate, 'color': Colors.green, 'progress': 0.6},
    {'name': 'History', 'icon': Icons.history, 'color': Colors.orange, 'progress': 0.4},
    {'name': 'Language', 'icon': Icons.language, 'color': Colors.purple, 'progress': 0.9},
  ];

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Define a GlobalKey for Scaffold

  final List<Map<String, dynamic>> recentQuizzes = [
    {
      'title': 'Basic Algebra', 
      'questions': 15,
      'duration': '10 mins',
      'difficulty': 'Easy',
      'completion': 0.7,
      'category': 'Math',
      'heroTag': 'quiz1'
    },
    {
      'title': 'World Capitals', 
      'questions': 20,
      'duration': '15 mins',
      'difficulty': 'Medium',
      'completion': 0.4,
      'category': 'Geography',
      'heroTag': 'quiz2'
    },
    {
      'title': 'Chemistry Basics', 
      'questions': 12,
      'duration': '8 mins',
      'difficulty': 'Easy',
      'completion': 0.9,
      'category': 'Science',
      'heroTag': 'quiz3'
    },
  ];

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() => recentQuizzes.shuffle());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;

return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the default leading icon
        title: Hero(
          tag: 'appTitle',
          child: Material(
            type: MaterialType.transparency,
            child: Text('QuizMaster',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.menu), // Hamburger icon on the right
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Open right-side drawer
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(isDarkMode),
              SizedBox(height: 25),

              // Progress Overview
              _buildProgressOverview(),
              SizedBox(height: 25),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoriesScreen()),
                    ),
                    child: Text('See All', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.3,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) => CategoryCard(
                  name: categories[index]['name'],
                  icon: categories[index]['icon'],
                  color: categories[index]['color'],
                  progress: categories[index]['progress'],
                  onTap: () => _navigateToQuizList(context, categories[index]),
                ),
              ),
              SizedBox(height: 25),

              // Recent Quizzes
              Text('Recent Quizzes', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 15),
              ...recentQuizzes.map((quiz) => QuizCard(
                title: quiz['title'],
                questionCount: quiz['questions'],
                duration: quiz['duration'],
                difficulty: quiz['difficulty'],
                completion: quiz['completion'],
                accentColor: _getCategoryColor(quiz['category']),
                onTap: () => _navigateToQuizDetails(context, quiz),
              )),
            ],
          ),
        ),
      ),


      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header (you can customize it with a profile image, etc.)
            UserAccountsDrawerHeader(
              accountName: Text('User Name'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile screen
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                // Navigate to notifications screen
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings screen
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign out'),
              onTap: () {
                // Sign out the user
                // You can implement your sign-out logic here
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search quizzes...',
          prefixIcon: Icon(Iconsax.search_normal),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            strokeWidth: 8,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Progress', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 5),
              Text('75% completion', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 5),
              Text('Current streak: 7 days 🔥', style: TextStyle(color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoryName) {
    final category = categories.firstWhere(
      (c) => c['name'] == categoryName,
      orElse: () => {'color': Colors.blue},
    );
    return category['color'];
  }

  void _navigateToQuizList(BuildContext context, Map<String, dynamic> category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizListScreen(
          categoryName: category['name'],
          categoryColor: category['color'],
          categoryIcon: category['icon'],
        ),
      ),
    );
  }

  void _navigateToQuizDetails(BuildContext context, Map<String, dynamic> quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailScreen(quiz),
      ),
    );
  }
}

class QuizDetailScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;

  const QuizDetailScreen(this.quiz, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: quiz['heroTag'],
          child: Material(
            type: MaterialType.transparency,
            child: Text(quiz['title']),
          ),
        ),
      ),
      body: Center(child: Text('Details for ${quiz['title']}')),
    );
  }
}