import 'package:flutter/material.dart';
import 'package:reflectly_admin/screens/settings_screen.dart';
import 'package:reflectly_admin/screens/mood_tracking_screen.dart';
import 'package:reflectly_admin/screens/home_screen.dart';
import 'package:reflectly_admin/screens/breathing_player_screen.dart';

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({super.key});

  static const purple = Color.fromARGB(255, 108, 104, 243);

  final List<Map<String, dynamic>> exercises = const [
    {
      "title": "Equal Breathing",
      "caption": "Balanced breathing helps you relax and concentrate.",
      "duration": "3 minutes",
      "pattern": "4-0-4-0",
      "image": "assets/images/breathing1.png",
      "color": Color(0xFFFDF5F3),
      "audio": "assets/audio/Breathing-3minutes.m4a",
    },
    {
      "title": "Box Breathing",
      "caption": "Box breathing is a powerful way of reducing stress.",
      "duration": "4 minutes",
      "pattern": "4-4-4-4",
      "image": "assets/images/breathing2.png",
      "color": Color(0xFFFDEDF2),
      "audio": "assets/audio/Breathing-4minutes.m4a",
    },
    {
      "title": "Relaxing Breath",
      "caption": "A calming technique for sleep and relaxation.",
      "duration": "5 minutes",
      "pattern": "4-7-8-0",
      "image": "assets/images/breathing3.png",
      "color": Color(0xFFE7F6F2),
      "audio": "assets/audio/Breathing-5minutes.m4a",
    },
    {
      "title": "Resonant Breathing",
      "caption": "A slow breathing pattern for relaxation.",
      "duration": "7 minutes",
      "pattern": "7-0-11-0",
      "image": "assets/images/breathing4.png",
      "color": Color(0xFFFDF5F3),
      "audio": "assets/audio/Breathing-7minutes.m4a",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Breathing ",
                  style: TextStyle(
                    color: purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 1.1,
                  ),
                ),
                const TextSpan(
                  text: "Exercises",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bigger and centered image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          ex["image"],
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Text and buttons
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex["title"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ex["caption"] ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BreathingPlayerScreen(
                                        title: ex["title"] ?? "",
                                        caption: ex["caption"] ?? "",
                                        image: ex["image"] ?? "",
                                        duration: ex["duration"] ?? "3 minutes",
                                        pattern: ex["pattern"] ?? "",
                                        color: ex["color"] ?? Colors.white,
                                        audio: ex["audio"],
                                      ),
                                    ),
                                  );},
                                child: const Text(
                                  "Start Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                ex["pattern"] ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: purple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ex["duration"] ?? "",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mood Tracking button
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MoodTrackingScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            // Home button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            // Settings button
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}