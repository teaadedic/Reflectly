import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  final String notebookTitle;
  const JournalScreen({Key? key, required this.notebookTitle})
    : super(key: key);

  static const purple = Color.fromARGB(255, 108, 104, 243);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences _prefs;
  late String _journalKey;
  late String _lastDateKey;

  // Personalized mental health prompts
  final List<String> moodPrompts = [
    "I'm feeling happy",
    "Today I feel anxious",
    "Grateful for...",
    "A challenge I faced",
    "A positive thought",
    "What I need right now",
  ];
  int? selectedPrompt;

  @override
  void initState() {
    super.initState();
    _journalKey = 'notebook_${widget.notebookTitle}';
    _lastDateKey = 'notebook_lastdate_${widget.notebookTitle}';
    _initJournal();
  }

  Future<void> _initJournal() async {
    _prefs = await SharedPreferences.getInstance();
    String? savedText = _prefs.getString(_journalKey);
    String? lastDate = _prefs.getString(_lastDateKey);

    // If it's a new day or first launch, add a new timestamp header
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastDate != today) {
      String now = DateFormat('MMMM d, yyyy – HH:mm').format(DateTime.now());
      savedText = (savedText ?? '') + '\n\n$now\n';
      await _prefs.setString(_lastDateKey, today);
      await _prefs.setString(_journalKey, savedText);
    }
    _controller.text = savedText ?? '';

    // Auto-save on every change
    _controller.addListener(() {
      _prefs.setString(_journalKey, _controller.text);
    });
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Optional: Clear journal (for testing/demo)
  void _clearJournal() async {
    await _prefs.remove(_journalKey);
    await _prefs.remove(_lastDateKey);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: JournalScreen.purple.withOpacity(0.15),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: JournalScreen.purple.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white54),
            tooltip: "Clear Journal",
            onPressed: _clearJournal,
          ),
        ],
        title: Text(
          widget.notebookTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Decorative background
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: JournalScreen.purple.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      color: JournalScreen.purple,
                      size: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "How are you feeling today?",
                      style: TextStyle(
                        color: JournalScreen.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Mood prompt bubbles
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(moodPrompts.length, (index) {
                    final isSelected = selectedPrompt == index;
                    return ChoiceChip(
                      label: Text(
                        moodPrompts[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: JournalScreen.purple,
                      backgroundColor: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedPrompt = index;
                          if (!_controller.text.contains(moodPrompts[index])) {
                            _controller.text +=
                                (_controller.text.isEmpty ? "" : "\n") +
                                "${moodPrompts[index]} ";
                            _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length),
                            );
                          }
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: JournalScreen.purple.withOpacity(0.10),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: JournalScreen.purple.withOpacity(0.13),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Scrollbar(
                        thickness: 4,
                        radius: const Radius.circular(12),
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Start writing your thoughts...",
                              hintStyle: TextStyle(
                                color: Colors.white38,
                                fontSize: 16,
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            cursorColor: JournalScreen.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Colors.white.withOpacity(0.3),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Private & auto-saved",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: JournalScreen.purple,
        icon: const Icon(Icons.check, color: Colors.black),
        label: const Text(
          "Done",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Journal saved!"),
              backgroundColor: Colors.black87,
            ),
          );
        },
      ),
    );
  }
}
