import 'dart:async'; // Add this import for Timer
import 'dart:convert';
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
  late List<dynamic> _messages = [];
  late List<Map<String, dynamic>> messages = [];
  var storage = FlutterSecureStorage();
  late String? role = '';
  late String? recipient_id = '0';
  late Timer _timer; // Timer for periodic updates
  late Map<String, dynamic> doctor = {};
  late String from = '';
  late String to = '';

  @override
  void initState() {
    storage = FlutterSecureStorage();
    getData();

    // Initialize timer
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      print('tik');
      if (from.isNotEmpty && to.isNotEmpty) {
        getData();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _timer.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  Future<dynamic> getData() async {
    print('Fetching messages...');
    //    var role = await storage.read(key: 'role');
    //    var recipient_id = await storage.read(key: 'recipient_id');
    //    var doctorData = await storage.read(key: 'doctor_data');
    //    var doctor = json.decode(doctorData!);
    var fromLoad = '';
    var toLoad = '';
    /*
    if (role == 'patient') {
      fromLoad = 'patient';
      toLoad = recipient_id!;
    } else {
      fromLoad = doctor['id'].toString();
      toLoad = 'patient';
    }

    try {
      var messagesLoad = await DatabaseHelper.fetchMessages(fromLoad, toLoad);
      print("msgs:" + messagesLoad.toString());

      if (mounted) {
        // Check if widget is still mounted before calling setState
        setState(() {
          this.role = role;
          this.doctor = doctor;
          from = fromLoad;
          to = toLoad;
          _messages = messagesLoad;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }*/
  }

  void _sendMessage(to) async {
    if (_messageController.text.trim().isEmpty) return;

    // Optimistically add the message to UI
    setState(() {
      _messages.add({
        '_text': _messageController.text,
        'isMe': true,
        'timestamp': DateTime.now(),
      });

      String respondent_title = role == 'patient' ? 'врача' : 'пациента';
      _messages.add({
        '_text': 'Сообщение от $respondent_title появится здесь...',
        'isMe': false,
        'timestamp': DateTime.now(),
      });
    });

    try {
      from = '1';
      print(from);
      print("its ud");
      print(to);
      print(_messageController.text);
      print("<,");
      await DatabaseHelper.insertData(_messageController.text, from, to);
      _messageController.clear();
      print("..............."); // Refresh messages after sending
      // await getData();
    } catch (e) {
      // Remove optimistic updates if failed
      if (mounted) {
        setState(() {
          _messages.removeLast();
          _messages.removeLast();
        });
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка отправки сообщения: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    to = args["id"];
    print(args);
    print("<<<<");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Чат с  ' + (args.toString()),
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
                  // Determine if message is from current user
                  final isMe =
                      message['_from'] == from || message['isMe'] == true;

                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            isMe
                                ? const Color.fromARGB(255, 36, 103, 158)
                                : Colors.grey[200],
                      ),
                      child: Text(
                        //message['_text'].toString(),
                        'helo',
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
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
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      _sendMessage(to);
                    },
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
