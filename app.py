from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
import os
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, db
from datetime import datetime
import logging
from textblob import TextBlob

# Load environment variables
load_dotenv()

# Load Firebase credentials
from firebase_credentials import firebase_credentials

# Initialize Firebase Admin SDK
cred = credentials.Certificate(firebase_credentials)
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://mentalchatbot-bc114-default-rtdb.asia-southeast1.firebasedatabase.app/'
})

app = Flask(__name__)
CORS(app)

# Configure the API key for Google Generative AI
genai.configure(api_key=os.getenv("API_KEY"))
fine_tuned_model_id = 'tunedModels/combineduserbotnew-mygyypipzzs6'

# Initialize total sentiment variable
total_sentiment = 0.0
sentiment_history = []  # List to hold sentiment history

# Define the sentiment analysis function
def analyze_sentiment(text):
    """Analyze sentiment using TextBlob."""
    blob = TextBlob(text)
    return blob.sentiment.polarity  # Returns a value between -1.0 (negative) and 1.0 (positive)

# Function to check for extreme mental health mentions
def check_extreme_cases(text):
    """Check for mentions of suicide or extreme distress."""
    suicide_keywords = ["suicide", "kill myself", "end it", "take my life", "I can't go on"]
    for keyword in suicide_keywords:
        if keyword in text.lower():
            return True
    return False

# Fetch conversation history for a session
def get_conversation_history(session_id):
    """Fetch previous conversation using the session ID."""
    conversations = db.reference('conversations').order_by_child('session_id').equal_to(session_id).get()
    if conversations:
        return " ".join([conv['user_query'] + " " + conv['response'] for conv in conversations.values()])
    return ""

# Endpoint for handling user queries and responses
@app.route('/api/query', methods=['POST'])
def handle_query():
    global total_sentiment  # Access the global variable
    data = request.json
    user_query = data.get('query')
    session_id = data.get('session_id')  # Use session_id to track the conversation

    # Log the incoming query
    logging.info(f"Received query: {user_query}")

    if not user_query:
        return jsonify({'error': 'Query cannot be empty.'}), 400

    # Check for extreme cases
    if check_extreme_cases(user_query):
        return jsonify({
            'response': "I'm really sorry to hear that you're feeling this way. Please reach out for help. "
                        "You can call the helpline at **9152987821**. They can assist you.",
            'sentiment': None  # Change 'N/A' to None (or 0.0 if you prefer a numeric value)
        }), 200

    # Fetch conversation history for the session
    conversation_history = get_conversation_history(session_id)
    full_input = conversation_history + " " + user_query

    try:
        # Generate content using the fine-tuned Gemini model
        model = genai.GenerativeModel(fine_tuned_model_id)
        response = model.generate_content(full_input)

        # Analyze sentiment using TextBlob
        sentiment = analyze_sentiment(user_query)

        # Update total sentiment and history
        total_sentiment += sentiment
        sentiment_history.append({'total_sentiment': total_sentiment, 'timestamp': datetime.now().isoformat()})

        # Log the response and sentiment
        logging.info(f"Generated response: {response.text}, Sentiment: {sentiment}")

        # Store conversation and sentiment trend in Realtime Database
        conversation_data = {
            'session_id': session_id,
            'user_query': user_query,
            'response': response.text,
            'sentiment': sentiment,  # This will be a float
            'timestamp': datetime.now().isoformat(),
        }
        db.reference('conversations').push(conversation_data)

        # Store cumulative sentiment trend separately
        db.reference('sentiment_trend').push({
            'total_sentiment': total_sentiment,
            'timestamp': datetime.now().isoformat()
        })

        return jsonify({'response': response.text, 'sentiment': sentiment}), 200
    except Exception as e:
        logging.error("Error occurred: %s", str(e))
        return jsonify({'error': 'Internal Server Error.'}), 500

# New endpoint to get sentiment trend
@app.route('/api/sentiment_trend', methods=['GET'])
def get_sentiment_trend():
    try:
        # Fetch sentiment trend from Firebase
        sentiment_trend_data = db.reference('sentiment_trend').get()

        # Check if sentiment_trend_data is None
        if sentiment_trend_data is None:
            return jsonify([]), 200  # Return an empty list if no data found

        # Format the data to return as a list
        formatted_data = [{'total_sentiment': data['total_sentiment'], 'timestamp': data['timestamp']} for data in sentiment_trend_data.values()]

        return jsonify(formatted_data), 200
    except Exception as e:
        logging.error("Error occurred while fetching sentiment trend: %s", str(e))
        return jsonify({'error': 'Internal Server Error.'}), 500

if __name__ == '__main__':
    app.run(debug=True)
 