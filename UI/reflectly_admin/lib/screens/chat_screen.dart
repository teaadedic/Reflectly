import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(title: const Text('Your Reflectly Chatbot')),
      //
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder:
                  (context, index) => ListTile(
                    title: Align(
                      alignment:
                          messages[index]['isUser']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              messages[index]['isUser']
                                  ? Colors.blueAccent
                                  : Colors.grey[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          messages[index]['message'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: Colors.deepPurple,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
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
    );
  }
}
