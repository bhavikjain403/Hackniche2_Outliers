from flask import Flask, request, jsonify
from voiceExtraction import extract_order_spacy_ner

app = Flask(__name__)

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


app.run(debug=True)