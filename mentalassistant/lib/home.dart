import 'package:flutter/material.dart';
import 'chat_page.dart'; // Import the chat page

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            // Logo on the left
            Image.asset(
              'assets/images/logo3.png', // Replace with your logo's path
              width: 60, // Adjust width to match the size of the title
              height: 60, // Adjust height to match the size of the title
            ),
            const SizedBox(width: 10), // Spacing between logo and title
            const Text(
              'EMOBUDDY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 22, // Adjust to match the size of the logo
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Organisation', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('About', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Blog', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Background color to white
        child: Stack(
          children: [
            // Left section with the image
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30), // Rounded top right corner
                  bottomRight: Radius.circular(30), // Rounded bottom right corner
                ),
                child: Image.asset(
                  'assets/images/mentalimage.png', // Path to your local image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Right section with text and button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), // Spacing
                    const Text(
                      'Your Personal AI Therapist',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Make real-time improvements to your mental well-being with your own AI chatbot.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'It produces daily insights and information just for you!',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5, // Adds shadow to button
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded button
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Chat With EMOBUDDY',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
