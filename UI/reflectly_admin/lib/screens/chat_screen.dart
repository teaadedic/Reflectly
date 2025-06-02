import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];

  // Replace this with your backend endpoint
  final String backendUrl = 'http://10.0.2.2:5000/api/Chatbot/message';

  void sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add({"message": text, "isUser": true});
    });

    _scrollToBottom();

    try {
      final reply = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': text}),
      );

      if (reply.statusCode == 200) {
        final replyData = json.decode(reply.body);
        final botMessage = replyData['reply'] ?? 'No reply';

        setState(() {
          messages.add({"message": botMessage, "isUser": false});
        });
        _scrollToBottom();
      } else {
        throw Exception('Failed to connect to backend');
      }
    } catch (e) {
      setState(() {
        messages.add({"message": "Error contacting bot: $e", "isUser": false});
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color userBubble = const Color(0xFFB9AEE6); // Softer purple
    final Color botBubble = const Color(0xFF6D5DB3); // Softer, less saturated

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C4DFF), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with back button, bot avatar and title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 26,
                        child: Icon(
                          Icons.smart_toy,
                          color: Color(0xFF7C4DFF),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Reflectly Chatbot',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.white24),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final isUser = messages[index]['isUser'];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                        margin: EdgeInsets.only(
                          top: 6,
                          bottom: 6,
                          left: isUser ? 60 : 0,
                          right: isUser ? 0 : 60,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isUser)
                              Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF7C4DFF),
                                  radius: 18,
                                  child: Icon(
                                    Icons.smart_toy,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isUser ? userBubble : botBubble,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(22),
                                    topRight: const Radius.circular(22),
                                    bottomLeft: Radius.circular(
                                      isUser ? 22 : 6,
                                    ),
                                    bottomRight: Radius.circular(
                                      isUser ? 6 : 22,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  messages[index]['message'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (isUser)
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF7C4DFF),
                                  radius: 18,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Floating input bar (unchanged)
                Container(
                  margin: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 18,
                    top: 4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (text) {
                            sendMessage(text);
                            _controller.clear();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          sendMessage(_controller.text);
                          _controller.clear();
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF7C4DFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
