import requests
from decouple import config

def menuExtract(img_loc):
    
    OCR_KEY = config("OCR_KEY")
    
    headers = {
        "apikey":OCR_KEY,
        "filetype": "JPG",
        "isTable": "true"
    }
    payload = {
        "isTable": "true"
    }
    output = {
        "success": True,
        "msg": "",
        "data": []
    }
    try:
        with open(img_loc, 'rb') as f:
            response = requests.post("https://api.ocr.space/parse/image", headers=headers, data=payload, files={"image": f}).json()
            data = response["ParsedResults"][0]["ParsedText"].split("\t\r")
            # print(data)
            menu = []
            for items in data:
                if "\t" in items:
                    val = {}
                    dish, price = items.split("\t")
                    val["dish"] = dish[1:]
                    val["price"] = price 
                    val["cuisine"] = "!"
                    menu.append(val)
            print(menu)            
        return menu
    except Exception as e:
        output["success"] = False 
        output["msg"] = str(e) 
        return output