import 'package:flutter/material.dart';
import 'package:reflectly_admin/screens/chat_screen.dart';
import 'package:reflectly_admin/screens/settings_screen.dart';
import 'package:reflectly_admin/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  static const purple = Color.fromARGB(255, 108, 104, 243);

  final List<String> moods = [
    "Happy",
    "Sad",
    "Neutral",
    "Anxious",
    "Angry",
    "Awesome",
  ];

  // Replace the moodIcons list with expressive emoji strings:
  final List<String> moodEmojis = [
    "😃", // Happy
    "😢", // Sad
    "😐", // Neutral
    "🥺", // Anxious (pleading face, fits anxious/uncertain)
    "😠", // Angry (angry face, clear and expressive)
    "🤩", // Awesome (star-struck, very positive)
  ];

  List<MoodEntry> moodEntries = [];
  int selectedMood = 2;

  @override
  void initState() {
    super.initState();
    loadMoodEntries();
  }

  Future<void> loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('moodEntries') ?? [];
    setState(() {
      moodEntries =
          entriesJson.map((e) => MoodEntry.fromMap(jsonDecode(e))).toList();
      if (moodEntries.isNotEmpty) {
        final lastMood = moodEntries.last.mood;
        final idx = moods.indexOf(lastMood);
        if (idx != -1) selectedMood = idx;
      }
    });
  }

  void selectMood(int moodIndex) async {
    setState(() {
      selectedMood = moodIndex;
      moodEntries.add(
        MoodEntry(mood: moods[moodIndex], timestamp: DateTime.now()),
      );
    });
    await saveMood(moods[moodIndex]);
  }

  Future<void> saveMood(String selectedMood) async {
    final newEntry = MoodEntry(mood: selectedMood, timestamp: DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('moodEntries') ?? [];
    final entries =
        entriesJson.map((e) => MoodEntry.fromMap(jsonDecode(e))).toList();
    entries.add(newEntry);
    await prefs.setStringList(
      'moodEntries',
      entries.map((e) => jsonEncode(e.toMap())).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Count moods for the bar chart
    Map<String, int> moodCounts = {for (var m in moods) m: 0};
    for (var entry in moodEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    final int maxCount =
        moodCounts.values.isNotEmpty
            ? moodCounts.values.reduce((a, b) => a > b ? a : b)
            : 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Mood ",
                style: TextStyle(
                  color: purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              TextSpan(
                text: "Tracking",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
            decoration: BoxDecoration(
              color: purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: purple,
                size: 28,
              ),
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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: purple.withOpacity(0.10),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: purple.withOpacity(0.15), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mood selection row
              Text(
                "How are you feeling?",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(moods.length, (i) {
                  return GestureDetector(
                    onTap: () => selectMood(i),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color:
                                selectedMood == i
                                    ? purple.withOpacity(0.18)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            moodEmojis[i],
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          moods[i],
                          style: TextStyle(
                            color: selectedMood == i ? purple : Colors.white70,
                            fontWeight:
                                selectedMood == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Large emoji for selected mood
              Text(
                moodEmojis[selectedMood],
                style: const TextStyle(fontSize: 56, color: purple),
              ),
              Text(
                moods[selectedMood],
                style: TextStyle(
                  color: purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 28),
              // Mood Chart
              Text(
                "Mood Chart",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: maxBarHeight + 40, // extra space for emoji and margin
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(moods.length, (i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          moodEmojis[i],
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 22,
                          height:
                              (moodCounts[moods[i]] ?? 0) > 0
                                  ? ((moodCounts[moods[i]]! / maxCount) *
                                          maxBarHeight)
                                      .clamp(0, maxBarHeight)
                                  : 0,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: i == selectedMood ? purple : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              // Show last mood entry
              if (moodEntries.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    "Last mood: ${moodEntries.last.mood} at ${DateFormat('MMM d, HH:mm').format(moodEntries.last.timestamp)}",
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left icon: MoodTrackingScreen (current, no navigation)
            Container(
              decoration: BoxDecoration(color: purple, shape: BoxShape.circle),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.bar_chart_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
            // Middle icon: HomeScreen navigation
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Container(
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
            ),
            // Right icon: SettingsScreen navigation
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
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
                child: Icon(Icons.settings, color: Colors.black, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const double maxBarHeight = 80.0;
