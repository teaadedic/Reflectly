import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

Future<void> saveMoodEntry(MoodEntry entry) async {
  final prefs = await SharedPreferences.getInstance();
  final entries = prefs.getStringList('mood_entries') ?? [];
  entries.add(jsonEncode(entry.toMap())); // <-- changed
  await prefs.setStringList('mood_entries', entries);
}

Future<List<MoodEntry>> loadMoodEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final entries = prefs.getStringList('mood_entries') ?? [];
  return entries
      .map((e) => MoodEntry.fromMap(jsonDecode(e)))
      .toList(); // <-- changed
}
