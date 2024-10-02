# EMOBUDDY
EMOBUDDY is an AI-powered mental health chatbot designed to provide emotional support and guidance to students. Developed using Flutter for the frontend and Flask for the backend, EMOBUDDY integrates with Google Gemini 1.5 Flash, fine-tuned on dataset of input column as user query and output column as empathetic answer on Google AI Studio, to deliver empathetic and personalized responses. The chatbot addresses various mental health issues like stress, anxiety, relationship challenges, and more.

# Features:
1.User Authentication:-

Secure login and sign-up pages using Firebase Authentication for user management and session handling.

![Screenshot 2024-10-02 162117](https://github.com/user-attachments/assets/edf9e433-155b-4026-940a-215b8b5ecdb4)

Signup page:-

![Screenshot 2024-10-02 162237](https://github.com/user-attachments/assets/3a76b1b6-1d70-4cbc-a943-04a7e427b11e)

3.Chat Interface:

Real-time conversation between users and the AI chatbot through a responsive chat page.
The chatbot offers emotional support and advice modeled after a therapist, providing users with thoughtful and empathetic responses.

![Screenshot 2024-10-02 162826](https://github.com/user-attachments/assets/8fcbfda5-3fb8-42d6-804b-e9f5c633a3ae)

chat interface:-

![Screenshot 2024-10-02 163308](https://github.com/user-attachments/assets/70cd0c81-6098-4683-adb4-57319a7b6016)

4.Sentiment Analysis and Visualization:-

EmoBuddy tracks the sentiment score of each chat interaction and calculates an emotional trend.
A Sentiment Trend Page visualizes these trends using bar and line graphs created with fl_chart, helping users monitor their emotional progress over time.

![Screenshot 2024-10-02 163912](https://github.com/user-attachments/assets/b19caf8d-5257-4caa-af98-ed6c13e73039)

4.Backend Powered by Flask:

The Flask backend handles user queries, processes sentiment analysis, and integrates with the Google Gemini API for advanced natural language processing.

5.Realtime Database :

Chat logs and sentiment data are stored securely using Firebase Realtime Database, ensuring real-time synchronization of user interactions and data.

# Technologies Used

Flutter (Dart) 

Flask (Python)

AI Model: Google Gemini 1.5 Flash

Authentication and Database: Firebase

Visualization: fl_chart

