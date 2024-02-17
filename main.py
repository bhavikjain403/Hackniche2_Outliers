from flask import Flask, request, jsonify
from voiceExtraction import extract_order_spacy_ner
from menuExtraction import menuExtract

from werkzeug.utils import secure_filename

from twilio.twiml.messaging_response import MessagingResponse, Message
from twilio.rest import Client
# from connect import db as db
from bson.json_util import dumps

from flask_cors import CORS
import os

from flask_pymongo import pymongo

from textblob import TextBlob
from decouple import config

import db

app = Flask(__name__)
CORS(app)

SID = config("TWILIO_ACCOUNT_SID")
Auth = config("TWILIO_AUTH_TOKEN")

client = Client(SID, Auth)
def respond(text, img):
    response = MessagingResponse()
    message = Message()
    message.body(text)
    
    # with open(img, "rb") as f:
    message.media(img)
    return str(response.append(message))

UPLOAD_FOLDER = os.getcwd()+'/submitted'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route('/reply', methods=['POST'])
def reply():
    message = request.form.get('Body').lower()
    num=request.form.get('From')[12:]
    img = 'https://raw.githubusercontent.com/dianephan/flask_upload_photos/main/UPLOADS/DRAW_THE_OWL_MEME.png'
    print("img", img)
    data=list(db.user_collection.find({"phone":num}))
    # msg = client.messages.create(
    #     body='Hello there!',
    #     from_='whatsapp:+14155238886',
    #     to='whatsapp:+919819396489'
    # )
    if len(data):
        return respond("Today's special is XYZ Food", img)
    else:
        return respond('You do not have an account. Please create an account first', img)

# Pushing Notifications using Twilio to WA
@app.route("/pushNotifs", methods=["POST"])
def push_notifications():
    if request.method == "POST":
        itemName = str(request.form["item"])
        # Finding Image from given Item
        doc = db.menu_collection.find_one({"name":itemName})
        image = doc["img"]
        price = doc["price"]
        print(image)
        
        respond(f"Enjoy Lovely {itemName} at just Rs: {price}", image)
        return jsonify("Found")
    else:
        return jsonify("Invalid Method")

@app.route("/extract", methods=["POST"])
def orderExtraction():
    if request.method == "POST":
        text = str(request.data.decode())
        print(text)

        output = {
            "status": True,
            "msg": "",
            "data": []
        }

        try:
            extracted = extract_order_spacy_ner(text)
            output["data"] = extracted
        except Exception as e:
            output["status"] = False 
            output["msg"] = str(e) 
        
        return jsonify(output)
    else:
        output = {
            "status": False,
            "msg": "Invalid Request Type",
            "data": []
        }
        return jsonify(output)


@app.route("/admin/menuextract", methods=["POST"])
def menuExtraction():
    if request.method=="POST":
        img = request.files['image']
        img_loc = os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(img.filename))
        img.save(img_loc)
        return menuExtract(img_loc)
    else:
        return jsonify("Invalid Method")

@app.route("/sentiment", methods=["POST"])
def senti():
    if request.method == "POST":
        text = str(request.data.decode())
        analysis = TextBlob(text)
        
        # Classify polarity as positive, negative, or neutral
        output = {
            "success": True,
            "msg": "",
        }
        if analysis.sentiment.polarity > 0:
            output["sentiment"] = "Positive"
        elif analysis.sentiment.polarity == 0:
            output["sentiment"] = "Neutral"
        else:
            output["sentiment"] = "Negative"
        return jsonify(output)


app.run(debug=True)