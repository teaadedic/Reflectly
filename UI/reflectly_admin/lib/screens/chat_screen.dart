import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  // Replace this with your backend endpoint
  final String backendUrl = 'http://192.168.1.2:5000/api/Chatbot/message';

  void sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add({"message": text, "isUser": true});
    });

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
      } else {
        throw Exception('Failed to connect to backend');
      }
    } catch (e) {
      setState(() {
        messages.add({"message": "Error contacting bot: $e", "isUser": false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflectly Chatbot'),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isUser = messages[index]['isUser'];
                return Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF7C4DFF),
                          radius: 18, // lighter purple
                          child: Icon(Icons.smart_toy, color: Colors.white),
                        ),
                      ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isUser
                                  ? Color(
                                    0xFFB39DDB,
                                  ) // user bubble: lighter purple
                                  : Color(
                                    0xFF4F378B,
                                  ), // bot bubble: deep purple
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isUser ? 18 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
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
                          radius: 18, // lighter purple
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF7C4DFF), // lighter purple
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
                  ),
                ),
                // Remove the blue circular container, use a black send button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // ElevatedButton to open ChatScreen
      // floatingActionButton: ElevatedButton(
      //   onPressed: () {
      //     // Navigator.push to ChatScreen
      //   },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Color(0xFFF3ECFF), // light purple
      //     shape: StadiumBorder(),
      //   ),
      //   child: Text('Open Chatbot', style: TextStyle(color: Colors.deepPurple)),
      // ),
    );
  }
}
