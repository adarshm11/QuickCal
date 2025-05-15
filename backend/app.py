from datetime import datetime
from firebase_admin import firestore
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
import os
import google.generativeai as genai
import firebase_admin

load_dotenv()

app = Flask(__name__)
CORS(app)

cred = firebase_admin.credentials.Certificate(os.getenv("GOOGLE_APPLICATION_CREDENTIALS"))

options = {
    "databaseURL": "https://console.firebase.google.com/u/0/project/calquick/firestore/databases/users/data"
}
firebaseApp = firebase_admin.initialize_app(credential=cred, options=options)

client = firebase_admin.firestore.client(firebaseApp, "users")
print("hello")



@app.route("/")
def root():
    return 'Entry point!'

@app.post('/signup')
def signup():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")


    if len(email) == 0 or len(password) == 0:
        return jsonify({"success":False, "error":"email & password"})

@app.post('/login')
def login():
    '''Receive login information, authenticate login, load chat history using Firebase'''
    data = request.get_json()
    username, password = data.get("username", ""), data.get("password", "")

    # print(f"username: {username}, password: {password}")
    return jsonify({"success": True, "message":"Logging in!"})

@app.post('/receive-event')
def receive_event():
    data = request.get_json()
    user_id = data["userId"]
    message = data.get("request", "")
    # print("message is", message)
   
    user_doc = client.collection("users").document(user_id)
    msgs     = user_doc.collection("messages")
    msgs.add({
      "role":      "user",
      "text":      message,
      "timestamp": firestore.SERVER_TIMESTAMP
    })

    history = []
    for doc in msgs.order_by("timestamp").stream():
        d = doc.to_dict()
        history.append(f"{d['role']}: {d['text']}")
    

    context = "\n".join(history)


    now = datetime.now()


    current_date = now.strftime("%Y-%m-%d")
    print(current_date)
    query = f'''
     {context}

    User message: "{message}"
    Ok, so you're a calendar assistant buddy that creates calendar events based on the users message. 
    Your goal is to create the raw contents of an .ics file that will be compiled into an actual .ics file
    which will be added to the users calendar in one click, and no other interaction. Use the users message
    any context required to fill in incomplete information, and unless another reminder is specified, set a 
    reminder for 30 minutes before. Make the length of event appropriate for the event at hand, and remember
    that the current day for the user is {current_date} and so is the date of your creation. 
    Ensure that the UID is randomized EVERYTIME. Do not include any extreneous characters in your response. Don't include text in the first word of the ics file contents 

    '''


    genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
    model    = genai.GenerativeModel("gemini-2.5-flash-preview-04-17")
    raw_ics  = model.generate_content(query).text.strip('\'" \n')
    if raw_ics.startswith("```") and raw_ics.endswith("```"):
        print("here in this if")
        raw_ics = raw_ics[3:-3]
    print(raw_ics)


    msgs.add({
      "role":      "assistant",
      "text":      raw_ics,
      "timestamp": firestore.SERVER_TIMESTAMP
    })

    print("Raw ics: ", raw_ics)

    return jsonify({ "response": raw_ics })


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)


