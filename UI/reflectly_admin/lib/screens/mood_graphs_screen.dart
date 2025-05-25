import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodGraphsScreen extends StatefulWidget {
  const MoodGraphsScreen({super.key});

  @override
  State<MoodGraphsScreen> createState() => _MoodGraphsScreenState();
}

class _MoodGraphsScreenState extends State<MoodGraphsScreen> {
  List<MoodEntry> entries = [];
  bool loading = true;

  // Mood to intensity mapping for line chart
  final Map<String, int> moodIntensity = {
    "Sad": 1,
    "Anxious": 2,
    "Neutral": 3,
    "Calm": 4,
    "Happy": 5,
    "Angry": 2,
    "Confused": 2,
    "Grateful": 5,
  };

  // Mood to emoji mapping for display
  final Map<String, String> moodEmoji = {
    "Happy": "😃",
    "Sad": "😢",
    "Calm": "😌",
    "Anxious": "😰",
    "Neutral": "😐",
    "Angry": "😡",
    "Confused": "😕",
    "Grateful": "🙏",
  };

  // Use this mapping for all mood emoji in your graphs:
  final Map<String, String> moodEmojis = {
    "Happy": "😃",
    "Sad": "😢",
    "Neutral": "😐",
    "Anxious": "🥺",
    "Angry": "😠",
    "Awesome": "🤩",
  };

  final Map<String, IconData> moodIcons = {
    "Happy": Icons.sentiment_very_satisfied,
    "Sad": Icons.sentiment_dissatisfied,
    "Neutral": Icons.sentiment_neutral,
    "Anxious":
        Icons
            .sentiment_very_dissatisfied, // Replace with a better icon if available
    "Calm": Icons.self_improvement,
    "Angry": Icons.mood_bad,
    "Confused": Icons.psychology,
    "Grateful": Icons.emoji_emotions,
  };

  final Map<String, Color> moodColors = {
    "Happy": Colors.amber,
    "Sad": Colors.purple,
    "Neutral": Colors.blue,
    "Calm": Colors.green,
    "Angry": Colors.red,
    "Awesome": Colors.pink,
    "Anxious": Colors.orange,
    "Confused": Colors.teal,
    "Grateful": Colors.cyan,
  };

  @override
  void initState() {
    super.initState();
    loadMoodEntries().then((loaded) {
      setState(() {
        entries = loaded;
        loading = false;
      });
    });
  }

  // Persistent storage helpers
  Future<void> saveMoodEntries(List<MoodEntry> moodEntries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = moodEntries.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('moodEntries', entriesJson);
  }

  Future<List<MoodEntry>> loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('moodEntries') ?? [];
    return entriesJson.map((e) => MoodEntry.fromMap(jsonDecode(e))).toList();
  }

  // Group moods by day for the last 7 days
  List<Map<String, dynamic>> getMoodPerDay() {
    final now = DateTime.now();
    List<Map<String, dynamic>> result = [];
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final dayEntries =
          entries
              .where(
                (e) =>
                    e.timestamp.year == day.year &&
                    e.timestamp.month == day.month &&
                    e.timestamp.day == day.day,
              )
              .toList();

      // Pick the latest mood for the day, or null
      MoodEntry? latest =
          dayEntries.isNotEmpty
              ? (dayEntries..sort((a, b) => b.timestamp.compareTo(a.timestamp)))
                  .first
              : null;
      result.add({"date": day, "mood": latest?.mood});
    }
    return result;
  }

  // Count frequency of each mood
  Map<String, int> getMoodCounts() {
    Map<String, int> counts = {};
    for (var e in entries) {
      counts[e.mood] = (counts[e.mood] ?? 0) + 1;
    }
    return counts;
  }

  // Count frequency of each mood for the past week
  Map<String, int> getMoodCountsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    Map<String, int> counts = {};
    for (var e in entries) {
      if (e.timestamp.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
          e.timestamp.isBefore(weekEnd.add(const Duration(days: 1)))) {
        counts[e.mood] = (counts[e.mood] ?? 0) + 1;
      }
    }
    return counts;
  }

  // Pie chart data: mood distribution
  List<PieChartSectionData> getPieSections(Map<String, int> counts) {
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    return counts.entries.map((e) {
      final percent = (e.value / total) * 100;
      final color = moodColors[e.key] ?? Colors.grey;
      return PieChartSectionData(
        color: color,
        value: e.value.toDouble(),
        title: "${percent.toStringAsFixed(1)}%",
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();
  }

  // Save a new mood entry
  Future<void> saveMood(String selectedMood, {String? optionalNote}) async {
    final newEntry = MoodEntry(
      mood: selectedMood,
      timestamp: DateTime.now(),
      note: optionalNote,
    );
    setState(() {
      entries.add(newEntry);
    });
    await saveMoodEntries(entries);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mood saved!')));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Mood Graphs",
            style: TextStyle(color: Colors.white), // <-- Make title white
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // <-- Make back arrow white
        ),
        backgroundColor: Colors.black,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final moodCounts = getMoodCounts();
    final moodPerDay = getMoodPerDay();
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekMoodCounts = getMoodCountsForWeek(weekStart);

    final maxMoodCount =
        moodCounts.values.isNotEmpty
            ? moodCounts.values.reduce((a, b) => a > b ? a : b)
            : 1;

    final maxWeekMoodCount =
        weekMoodCounts.values.isNotEmpty
            ? weekMoodCounts.values.reduce((a, b) => a > b ? a : b)
            : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mood Graphs",
          style: TextStyle(color: Colors.white), // <-- Make title white
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // <-- Make back arrow white
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Mood Frequency",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  BarChart(
                    BarChartData(
                      barGroups: List.generate(moodCounts.length, (i) {
                        final moods = moodCounts.keys.toList();
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: moodCounts[moods[i]]!.toDouble(),
                              color: Colors.deepPurpleAccent,
                              width: 24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48,
                            getTitlesWidget: (value, meta) {
                              final moods = moodCounts.keys.toList();
                              if (value.toInt() < 0 ||
                                  value.toInt() >= moods.length) {
                                return const SizedBox.shrink();
                              }
                              final mood = moods[value.toInt()];
                              final emoji = moodEmojis[mood] ?? "";
                              return Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              );
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: true, horizontalInterval: 1),
                      borderData: FlBorderData(show: false),
                      maxY:
                          maxMoodCount < 5
                              ? 5
                              : maxMoodCount + 1, // always fits
                      groupsSpace: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Mood Distribution",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 320,
              child: Column(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: getPieSections(moodCounts),
                        centerSpaceRadius: 70,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 18,
                    runSpacing: 8,
                    children:
                        moodCounts.keys.map((mood) {
                          final color = moodColors[mood] ?? Colors.grey;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                mood,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Mood This Week",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 320, // Increased height
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(weekMoodCounts.length, (i) {
                    final moods = weekMoodCounts.keys.toList();
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: weekMoodCounts[moods[i]]!.toDouble(),
                          color:
                              moodColors[moods[i]] ?? Colors.deepPurpleAccent,
                          width: 32, // Thicker bars
                          borderRadius: BorderRadius.circular(16),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY:
                                maxWeekMoodCount < 5
                                    ? 5
                                    : maxWeekMoodCount + 1, // match maxY
                            color: Colors.white12,
                          ),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          // Only show numbers vertically
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44, // adjust as needed
                        getTitlesWidget: (value, meta) {
                          final moods = weekMoodCounts.keys.toList();
                          final moodEmojis = {
                            "Angry": "😡",
                            "Awesome": "😍",
                            "Neutral": "😐",
                            "Sad": "😢",
                            "Anxious": "😰",
                            "Happy": "😃",
                          };
                          if (value.toInt() < 0 ||
                              value.toInt() >= moods.length) {
                            return const SizedBox.shrink();
                          }
                          final mood = moods[value.toInt()];
                          final emoji = moodEmojis[mood] ?? "";
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                mood,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(emoji, style: const TextStyle(fontSize: 18)),
                            ],
                          );
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 1),
                  borderData: FlBorderData(show: false),
                  maxY:
                      maxWeekMoodCount < 5
                          ? 5
                          : maxWeekMoodCount + 1, // <-- THIS LINE
                  groupsSpace: 24, // More space between bars
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MoodEntry model
class MoodEntry {
  final String mood;
  final DateTime timestamp;
  final String? note;

  MoodEntry({required this.mood, required this.timestamp, this.note});

  Map<String, dynamic> toMap() => {
    'mood': mood,
    'timestamp': timestamp.toIso8601String(),
    'note': note,
  };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
    mood: map['mood'],
    timestamp: DateTime.parse(map['timestamp']),
    note: map['note'],
  );
}
