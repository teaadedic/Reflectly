import 'dart:math';
import 'package:flutter/material.dart';
import '../services/quote_service.dart';

final List<String> imagePaths = [
  'assets/images/mental_health1.png',
  'assets/images/mental_health2.png',
  'assets/images/mental_health3.png',
  'assets/images/mental_health4.png',
];

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  List<String> selectedQuotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomQuotes();
  }

  void _loadRandomQuotes() async {
    setState(() => isLoading = true);
    List<String> allQuotes = await QuoteService.loadQuotes();
    allQuotes.shuffle(Random());
    setState(() {
      selectedQuotes = allQuotes.take(4).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Daily Quotes",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: ListView.builder(
                  itemCount: selectedQuotes.length,
                  itemBuilder: (context, index) {
                    final quote = selectedQuotes[index];
                    final imagePath = imagePaths[index % imagePaths.length];
                    return Card(
                      color: const Color(0xFF23222A),
                      margin: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 4,
                      ),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  imagePath,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 80,
                                            color: Colors.white24,
                                          ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '"$quote"',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadRandomQuotes,
        tooltip: 'Refresh Quotes',
        child: const Icon(Icons.refresh),
      ),
      backgroundColor: Colors.black,
    );
  }
}
