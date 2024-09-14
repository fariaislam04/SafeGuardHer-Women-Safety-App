import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');
  final TextEditingController _messageController = TextEditingController();
  late Stream<DatabaseEvent> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream = _messagesRef.onValue;
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _messagesRef.push().set({
        'text': _messageController.text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final messages = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  final messageWidgets = messages.entries.map((entry) {
                    final message = Map<String, dynamic>.from(entry.value);
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(DateTime.fromMillisecondsSinceEpoch(message['timestamp']).toString()),
                    );
                  }).toList();

                  return ListView(
                    children: messageWidgets,
                  );
                }

                return Center(child: Text('No messages yet.'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
