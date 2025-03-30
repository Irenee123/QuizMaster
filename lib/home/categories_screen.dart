import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'quiz_list_screen.dart';
import 'widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': "Science", 'icon': Iconsax.bezier, 'color': Colors.blue, 'progress': 0.75},
    {'name': "Math", 'icon': Iconsax.calculator, 'color': Colors.green, 'progress': 0.6},
    {'name': "History", 'icon': Iconsax.buildings, 'color': Colors.amber, 'progress': 0.4},
    {'name': "Languages", 'icon': Iconsax.translate, 'color': Colors.purple, 'progress': 0.9},
    {'name': "Technology", 'icon': Iconsax.code, 'color': Colors.red, 'progress': 0.3},
    {'name': "Arts", 'icon': Iconsax.activity, 'color': Colors.pink, 'progress': 0.5},
  ];

  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Categories", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Iconsax.search_normal),
            onPressed: () => _showSearchSheet(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
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
      ),
    );
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

void _showSearchSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: 300,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: Icon(Iconsax.search_normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(categories[index]['icon'], color: categories[index]['color']),
                  title: Text(categories[index]['name']),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToQuizList(context, categories[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}