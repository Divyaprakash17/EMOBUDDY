import 'package:flutter/material.dart';
import 'API.dart';
import 'sentimentTrendPage.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  double totalSentiment = 0.0;
  List<Map<String, dynamic>> sentimentHistory = [];
  String sessionId = Uuid().v4();

  Future<void> _sendQuery() async {
    if (_queryController.text.isEmpty) return;

    _messages.add({
      'text': _queryController.text,
      'type': 'user',
    });

    setState(() {
      _queryController.clear();
    });

    try {
      final response = await sendQuery(_messages.last['text']!, sessionId);

      totalSentiment += response['sentiment'];

      // Update sentiment history with the latest sentiment
      sentimentHistory.add({
        'total_sentiment': totalSentiment,
      });

      _messages.add({
        'text': response['response'],
        'type': 'bot',
      });

      setState(() {});
    } catch (e) {
      _messages.add({
        'text': 'Error: ${e.toString()}',
        'type': 'bot',
      });

      setState(() {});
    }
  }

  Future<void> _fetchSentimentHistory() async {
    try {
      final history = await fetchSentimentTrend();
      // Ensure history is not empty
      if (history.isNotEmpty) {
        setState(() {
          sentimentHistory = history;
        });
      } else {
        print('No sentiment history available.');
      }
    } catch (e) {
      print('Error fetching sentiment history: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSentimentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with EMOBUDDY', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,  // Set transparency
              child: Image.asset(
                'assets/images/logo4.png',
                fit: BoxFit.cover,  // Fit the image fully as a background
              ),
            ),
          ),
          // Foreground content (chat area)
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUserMessage = message['type'] == 'user';

                      return Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            message['text']!,
                            style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      decoration: const InputDecoration(
                        labelText: 'Type your message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendQuery,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total Sentiment: $totalSentiment',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SentimentTrendPage(sentimentHistory: sentimentHistory),
                    ),
                  );
                },
                child: const Text('View Sentiment Trend'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
