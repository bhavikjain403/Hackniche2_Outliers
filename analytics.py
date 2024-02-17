import db
from wordcloud import WordCloud
import os
from itertools import permutations
from collections import defaultdict

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

support_threshold = 2
confidence_threshold = 0.6
k=3
# calculating candidate and pruned candidate mapping
def candidate_generation(baskets, support_threshold=2):
    # will need these later
    basket_lengths = [len(i) for i in baskets]
    mapping = defaultdict(lambda : 0)

    for ton_length in range(1, k+1):
        # loop over baskets to create permutations
        for basket in baskets:
            perms = list(permutations(basket, ton_length))
        # count of each permutation
        for permutation in perms:
            mapping[permutation] += 1
    return dict(mapping)


def pruning(mapping):
    # loop over all keys in dict and remove all having length less than support threshold
    dict_keys = list(mapping.keys())[:]
    for key in dict_keys:
        if mapping[key] < support_threshold:
            del mapping[key]

    return dict(mapping)

# calculating confidence
def confidence_calc(mapping):
    confidence = {}
    for value, key in enumerate(mapping):
        # print(key, mapping[key], len(key))'
        if(len(key)==k):
            ele = key
            confidence[f"({ele[0]}, {ele[1]}) -> {ele[2]}"] = mapping[ele]/mapping[(ele[0], ele[1])]

    for value, key in enumerate(mapping):
        # print(key, mapping[key], len(key))'
        if(len(key)==k):
            ele = key
            confidence[f"{ele[0]} -> ({ele[1]}, {ele[2]})"] = mapping[ele]/mapping[(ele[0],)]
    return confidence


# displaying top 5 rules
def display_top(conf):
    dict_keys = list(conf.keys())[:]
    for key in dict_keys:
        if conf[key] < confidence_threshold:
            del conf[key]
    print("Top Association Rules are: ")
    result = []
    for key, val in conf.items():
        print(f"Association Rule: '{key}', confidence={val}")
        result.append(key)
    return result

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
        for item in x['items']:
            for _ in range(item['quantity']):
                temp.append(item['name'])
        baskets.append(temp)
    # print(baskets)
            
    candidate_mapping = candidate_generation(baskets, support_threshold)
    mapping = pruning(candidate_mapping)
    print(mapping)

    conf = confidence_calc(mapping)
    # for key, val in conf.items():
    #     print(f"Association Rule: '{key}', confidence={val}")

    result = display_top(conf)
    output["basket_analysis"] = result
    return output