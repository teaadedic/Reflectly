import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BreathingPlayerScreen extends StatefulWidget {
  final String title;
  final String caption;
  final String image;
  final String duration;
  final String pattern;
  final Color color;
  final String? audio;

  const BreathingPlayerScreen({
    super.key,
    required this.title,
    required this.caption,
    required this.image,
    required this.duration,
    required this.pattern,
    required this.color,
    this.audio,
  });

  @override
  State<BreathingPlayerScreen> createState() => _BreathingPlayerScreenState();
}

class _BreathingPlayerScreenState extends State<BreathingPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.0;
  Timer? timer;
  int totalSeconds = 0;
  int elapsedSeconds = 0;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    totalSeconds = _parseDuration(widget.duration);
    _player = AudioPlayer();
    _loadAudio();

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        timer?.cancel();
        setState(() {
          isPlaying = false;
          elapsedSeconds = totalSeconds;
          progress = 1.0;
        });
      }
    });
  }

  Future<void> _loadAudio() async {
    if (widget.audio != null) {
      try {
        await _player.setAsset(widget.audio!);
      } catch (e) {
        print('Audio load error: $e');
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  int _parseDuration(String duration) {
    final parts = duration.split(' ');
    if (parts.length >= 2 && int.tryParse(parts[0]) != null) {
      return int.parse(parts[0]) * 60;
    }
    return 180;
  }

  void _togglePlay() async {
    if (isPlaying) {
      timer?.cancel();
      await _player.pause();
    } else {
      if (elapsedSeconds >= totalSeconds) {
        elapsedSeconds = 0;
        progress = 0.0;
        await _player.seek(Duration.zero);
      }
      await _player.play();
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() {
          elapsedSeconds++;
          progress = elapsedSeconds / totalSeconds;
          if (elapsedSeconds >= totalSeconds) {
            timer?.cancel();
            isPlaying = false;
          }
        });
      });
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _restart() async {
    timer?.cancel();
    elapsedSeconds = 0;
    progress = 0.0;
    isPlaying = false;
    await _player.seek(Duration.zero);
    setState(() {});
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  String _getDescription(String pattern) {
    switch (pattern) {
      case "4-0-4-0":
        return "Inhale through your nose for 4 seconds, hold your breath for 0 seconds, exhale through your mouth for 4 seconds, and hold your breath for 0 seconds. Repeat.";
      case "4-4-4-4":
        return "Inhale through your nose for 4 seconds, hold your breath for 4 seconds, exhale through your mouth for 4 seconds, and hold your breath for 4 seconds. Repeat.";
      case "4-7-8-0":
        return "Inhale through your nose for 4 seconds, hold your breath for 7 seconds, exhale through your mouth for 8 seconds, and hold your breath for 0 seconds. Repeat.";
      case "7-0-11-0":
        return "Inhale through your nose for 7 seconds, hold your breath for 0 seconds, exhale through your mouth for 11 seconds, and hold your breath for 0 seconds. Repeat.";
      default:
        return "Breathe in deeply and exhale slowly. Repeat.";
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color.fromARGB(255, 108, 104, 243);
    const double barHeight = 14;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.97,
            margin: const EdgeInsets.symmetric(vertical: 18),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular image with border
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: purple, width: 5),
                  ),
                  child: ClipOval(
                    child: Image.asset(widget.image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Pattern: ${widget.pattern}",
                  style: TextStyle(
                    fontSize: 18,
                    color: purple,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  _getDescription(widget.pattern),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                // Centered play/pause button
                Center(
                  child: IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 64,
                      color: Colors.black,
                    ),
                    onPressed: _togglePlay,
                  ),
                ),
                const SizedBox(height: 24),
                // Progress bar andtime
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            _formatTime(elapsedSeconds),
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const Spacer(),
                          Text(
                            widget.duration,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Background bar
                          Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                barHeight / 2,
                              ),
                            ),
                          ),
                          // Gradient progress bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: barHeight,
                            width:
                                (MediaQuery.of(context).size.width * 0.97 -
                                    48) *
                                progress.clamp(0.0, 1.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 108, 104, 243),
                                  Color(0xFF8F7CF8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                barHeight / 2,
                              ),
                            ),
                          ),
                          // Thumb indicator
                          Positioned(
                            left:
                                ((MediaQuery.of(context).size.width * 0.97 -
                                        48 -
                                        barHeight) *
                                    progress.clamp(0.0, 1.0)),
                            child: Container(
                              width: barHeight,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: purple, width: 3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Replay button centered below progress bar
                Center(
                  child: IconButton(
                    icon: Icon(Icons.replay, color: Colors.grey[400], size: 32),
                    onPressed: _restart,
                    tooltip: "Replay",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
