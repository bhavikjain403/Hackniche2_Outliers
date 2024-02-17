from flask import Flask
from flask_pymongo import pymongo



CONNECTION_STRING = "mongodb+srv://bhavikjain403:3JXLUL5N1pzApsyb@cluster0.1deu8rv.mongodb.net/?retryWrites=True&w=majority"
client = pymongo.MongoClient(CONNECTION_STRING)
db = client.get_database('test')
user_collection = pymongo.collection.Collection(db, 'users')
menu_collection = pymongo.collection.Collection(db, 'menus')
orders_collection = pymongo.collection.Collection(db, 'orders')

# for item in data:
#     x = menu_collection.insert_one(item)
#     print(item["name"])