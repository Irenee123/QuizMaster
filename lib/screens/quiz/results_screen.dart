import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Map<String, dynamic> quiz;
  final List<bool?> answers;
  final List<Map<String, dynamic>> questions;

  const ResultsScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.quiz,
    required this.answers,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(
                      percentage >= 70 ? Colors.green : 
                      percentage >= 40 ? Colors.orange : Colors.red,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$score/$totalQuestions',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '${percentage}%',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(
                      'Question ${index + 1}',
                      style: TextStyle(
                        color: answers[index] == true ? Colors.green : Colors.red,
                      ),
                    ),
                    leading: Icon(
                      answers[index] == true ? Icons.check : Icons.close,
                      color: answers[index] == true ? Colors.green : Colors.red,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questions[index]['explanation'] ?? 'No explanation available',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Correct answer: ${questions[index]['options'][questions[index]['correctIndex']]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.popUntil(
                context, 
                (route) => route.isFirst
              ),
              icon: Icon(Iconsax.home),
              label: Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}