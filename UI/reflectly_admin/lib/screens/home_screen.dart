import 'package:flutter/material.dart';
import 'package:reflectly_admin/screens/chat_screen.dart';
import 'package:reflectly_admin/screens/breathing_exercises_screen.dart';
import 'package:reflectly_admin/screens/mood_graphs_screen.dart';
import 'package:reflectly_admin/screens/quotes_screen.dart';
import 'package:reflectly_admin/screens/notebook_selection_screen.dart';
import 'package:reflectly_admin/screens/settings_screen.dart';
import 'package:reflectly_admin/screens/mood_tracking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const purple = Color.fromARGB(255, 108, 104, 243);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Reflect.",
                    style: TextStyle(
                      color: purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  TextSpan(
                    text: " Heal. Grow.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: purple, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 0.95,
                  children: [
                    _HomeCard(
                      image: 'assets/images/journaling.png',
                      label: 'Journaling',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotebookSelectionScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeCard(
                      image: 'assets/images/breathing.png',
                      label: 'Breathing Exercises',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreathingExercisesScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeCard(
                      image: 'assets/images/mood_graphs.png',
                      label: 'Mood Graphs',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodGraphsScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeCard(
                      image: 'assets/images/quotes.png',
                      label: 'Quotes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuotesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const ChatScreen()),
                //     );
                //   },
                //   child: const Text("Open Chatbot"),
                // ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mood Tracking icon with navigation
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoodTrackingScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            // Middle icon (no navigation, just for design)
            Container(
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.grid_view_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
            // Settings icon with navigation
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.settings, color: Colors.black, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _HomeCard({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: Colors.deepPurple.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
