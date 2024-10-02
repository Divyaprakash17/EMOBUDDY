import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to send a query to the backend and get a response, with session_id for context
Future<Map<String, dynamic>> sendQuery(String query, String sessionId) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/api/query'), // Update this to match your backend URL
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'query': query,
      'session_id': sessionId, // Pass session ID to maintain context
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return {
      'response': jsonResponse['response'] ?? 'No response',
      'sentiment': jsonResponse['sentiment'] ?? 0.0, // Ensure this field is present
    };
  } else {
    throw Exception('Failed to get response from server');
  }
}

// Function to fetch the sentiment trend from the backend
Future<List<Map<String, dynamic>>> fetchSentimentTrend() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/api/sentiment_trend'), // Update this to match your backend URL
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonResponse);
  } else {
    throw Exception('Failed to get sentiment trend from server');
  }
}