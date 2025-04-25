import 'package:flutter/material.dart';
import 'package:flutter_application_training/utils/mysql.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  var storage;
  late String? role = '';

  @override
  void initState() {
    super.initState();
    getRole();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    await DatabaseHelper.insertData('a', 'b');
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isMe': true,
          'timestamp': DateTime.now(),
        });
        _messages.add({
          'text': 'Сообщение от врача появится здесь...',
          'isMe': false,
          'timestamp': DateTime.now(),
        });
        _messageController.clear();
      });
    }
  }

  Future<dynamic> getRole() async {
    var messages = await DatabaseHelper.selectData();
    print("msgs:" + messages.toString());
    storage = FlutterSecureStorage();
    role = await storage.read(key: 'role');

    print(role);
    setState(() {
      role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Чат с  ${role != null ? (role == 'doctor' ? 'пациентом' : 'доктором') : ''}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 103, 158),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return Align(
                    alignment: message['isMe']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: message['isMe']
                            ? const Color.fromARGB(255, 36, 103, 158)
                            : Colors.grey[200],
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color:
                              message['isMe'] ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      backgroundColor: const Color.fromARGB(255, 36, 103, 158),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
