from flask import Flask, request, jsonify
from voiceExtraction import extract_order_spacy_ner
from menuExtraction import menuExtract
from werkzeug.utils import secure_filename
import requests
import os
from textblob import TextBlob

app = Flask(__name__)

UPLOAD_FOLDER = os.getcwd()+'/submitted'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/extract", methods=["POST"])
def orderExtraction():
    if request.method == "POST":
        text = str(request.data.decode())
        print(text)

        output = {
            "success": True,
            "msg": "",
            "data": []
        }

        try:
            extracted = extract_order_spacy_ner(text)
            output["data"] = extracted
        except Exception as e:
            output["success"] = False 
            output["msg"] = str(e) 
        
        return jsonify(output)
    else:
        output = {
            "success": False,
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