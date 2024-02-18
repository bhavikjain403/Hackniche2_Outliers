import db
from wordcloud import WordCloud
import os
from itertools import permutations
from collections import defaultdict
from apyori import apriori

def getSales():
    # Total Profit, Weekly Earning, Weekly Growth, Day Wise Earnings, Recent Orders
    data = db.orders_collection.find({})
    menu = db.menu_collection.find({})
    price, dishes = 0, 0
    cuisines = {'North Indian':0 , 'Chinese':0 , 'Continental':0 , 'Asian':0 , 'Italian':0 , 'Beverages':0, 'Desserts':0, "Mediterranean":0}
    dish = defaultdict(int)
    for i in data:
        for item in i["items"]:
            name = item["name"]
            quantity = item["quantity"]
            dishes += quantity
            menu = db.menu_collection.find({"name": name})
            for x in menu:
                print(name, x)
                dish[name] += 1
                cuisines[x["cuisine"]] += 1
                print(name, x["price"]*quantity)
                price += x["price"]*quantity
    print("Total Revenue:", price)
    print("Total Items Sold:", dishes)
    print("Cuisines: ", (sorted(cuisines.items(), key = lambda item: item[1], reverse=True)))
    print("Dishes: ",(sorted(dish.items(), key = lambda item: item[1], reverse=True)))
    
    output = {}
    output["Total Revenue"] = price 
    output["Total Items Sold"] = dishes 
    output["Top Cuisines"] = sorted(cuisines.items(), key = lambda item: item[1], reverse=True)
    output["Top Selling Dish"] = sorted(dish.items(), key = lambda item: item[1], reverse=True)

    return output

def getSocial():
    # Promotions, Push Notifications, Embed Social Media, Change Menu, OCR Menu
    pass


def getRating():
    # Market Basket Analysis, Avg Ratings, Recent Reviews, WordCloud for Reviews
    output = {}
    
    data = db.reviews_collection.find({})
    
    # avg rating and recent reviews
    rating = 0
    length = 0
    reviews = []
    for x in data:
        rating += x["rating"]
        length += 1
        reviews.append(x['review'])
    rating /= length
    output["avg_rating"] = rating
    output["reviews"] = reviews
    
    # Wordcloud
    all_words = ""
    for review in output["reviews"]:
        all_words += ' ' + review
    wordcloud = WordCloud(width = 600, height = 400, random_state=1, background_color='black',
                      colormap='viridis', collocations=False).generate(all_words)
    wordcloud.to_file("wordcloud.png")
    # cv2.imwrite("analytics/wordcloud.jpg", wordcloud)
    output["wordcloud"] = "wordcloud.png"


    # Market Basket Analysis
    out = db.orders_collection.find({})
    baskets = []
    for x in out:
        temp = []
        # print(x)
        for item in x['items']:
            for _ in range(item['quantity']):
                temp.append(item['name'])
        baskets.append(temp)
    print(baskets)

    
    rules = apriori(transactions = baskets, min_support = 0.003, min_confidence = 0.2, min_lift = 3, min_length = 2, max_length = 2)

    ## Displaying the first results coming directly from the output of the apriori function
    results = list(rules)
    print("Results:", results)

    rules = []
    for result in results:
        lhs = tuple(result[2][0][0])[0]
        rhs = tuple(result[2][0][1])[0]
        conf = result[1]
        rules.append(f"{lhs} -> {rhs} with Score: {round(conf, 3)*10}")
    
    output["basket_analysis"] = rules
    return output