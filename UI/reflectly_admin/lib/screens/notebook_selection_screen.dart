import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_screen.dart';

class NotebookSelectionScreen extends StatefulWidget {
  const NotebookSelectionScreen({super.key});

  @override
  State<NotebookSelectionScreen> createState() =>
      _NotebookSelectionScreenState();
}

class _NotebookSelectionScreenState extends State<NotebookSelectionScreen> {
  List<String> _notebooks = [];
  final Set<String> _selectedForDelete = {};
  bool _deleteMode = false;

  static const List<String> defaultPrompts = [
    "What are you grateful for today?",
    "Describe a challenge you faced and how you handled it.",
    "Write about a happy moment from today.",
    "What is something you learned today?",
    "How are you feeling right now?",
  ];

  @override
  void initState() {
    super.initState();
    _loadNotebooks();
  }

  Future<void> _loadNotebooks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notebooks = prefs.getStringList('notebook_titles') ?? ['My Journal'];
    });
  }

  Future<void> _addNotebook(String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_notebooks.contains(name)) {
      setState(() {
        _notebooks.add(name);
      });
      await prefs.setStringList('notebook_titles', _notebooks);
      // Initialize with prompts (same as My Journal)
      String now = DateTime.now().toString();
      String prompts = defaultPrompts.map((p) => "- $p").join('\n');
      await prefs.setString('notebook_$name', '\n\n$now\n$prompts\n');
    }
  }

  Future<void> _deleteSelectedNotebooks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notebooks.removeWhere((n) => _selectedForDelete.contains(n));
    });
    await prefs.setStringList('notebook_titles', _notebooks);
    for (var n in _selectedForDelete) {
      await prefs.remove('notebook_$n');
    }
    setState(() {
      _selectedForDelete.clear();
      _deleteMode = false;
    });
  }

  void _showAddNotebookDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              "Create New Notebook",
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Notebook name",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white54),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: JournalScreen.purple,
                ),
                child: const Text(
                  "Create",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  String name = controller.text.trim();
                  if (name.isNotEmpty && !_notebooks.contains(name)) {
                    await _addNotebook(name);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "My Notebooks",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_deleteMode)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  tooltip: "Cancel",
                  onPressed: () {
                    setState(() {
                      _deleteMode = false;
                      _selectedForDelete.clear();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: "Delete Selected",
                  onPressed:
                      _selectedForDelete.isEmpty
                          ? null
                          : () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: const Text(
                                      "Delete Notebooks",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: const Text(
                                      "Are you sure you want to delete the selected notebooks?",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white54,
                                          ),
                                        ),
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirm == true) {
                              await _deleteSelectedNotebooks();
                            }
                          },
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              tooltip: "Delete Notebooks",
              onPressed: () {
                setState(() {
                  _deleteMode = true;
                });
              },
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _notebooks.length,
        itemBuilder: (context, index) {
          final notebook = _notebooks[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 4,
            child: ListTile(
              leading:
                  _deleteMode
                      ? Checkbox(
                        value: _selectedForDelete.contains(notebook),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedForDelete.add(notebook);
                            } else {
                              _selectedForDelete.remove(notebook);
                            }
                          });
                        },
                        activeColor: Colors.redAccent,
                      )
                      : Icon(Icons.book, color: JournalScreen.purple),
              title: Text(
                notebook,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing:
                  _deleteMode
                      ? null
                      : const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 18,
                      ),
              onTap:
                  _deleteMode
                      ? () {
                        setState(() {
                          if (_selectedForDelete.contains(notebook)) {
                            _selectedForDelete.remove(notebook);
                          } else {
                            _selectedForDelete.add(notebook);
                          }
                        });
                      }
                      : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    JournalScreen(notebookTitle: notebook),
                          ),
                        );
                      },
            ),
          );
        },
      ),
      floatingActionButton:
          !_deleteMode
              ? FloatingActionButton.extended(
                backgroundColor: JournalScreen.purple,
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text(
                  "New Notebook",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _showAddNotebookDialog,
              )
              : null,
    );
  }
}
