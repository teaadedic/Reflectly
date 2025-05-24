class MoodEntry {
  final String mood; // e.g., "Happy"
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
