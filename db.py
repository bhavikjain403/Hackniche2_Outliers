from flask import Flask
from flask_pymongo import pymongo
from bson.objectid import ObjectId



CONNECTION_STRING = "mongodb+srv://bhavikjain403:3JXLUL5N1pzApsyb@cluster0.1deu8rv.mongodb.net/?retryWrites=True&w=majority"
client = pymongo.MongoClient(CONNECTION_STRING)
db = client.get_database('test')
user_collection = pymongo.collection.Collection(db, 'users')
menu_collection = pymongo.collection.Collection(db, 'menus')
orders_collection = pymongo.collection.Collection(db, 'orders')
reviews_collection = pymongo.collection.Collection(db, 'reviews')

# data = [
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://images.immediate.co.uk/production/volatile/sites/30/2021/02/butter-chicken-ac2ff98.jpg?quality=90&resize=440,400",
#     "name": "Butter Chicken",
#     "price": 300,
#     "quantity": 2,
#     "veg": 2,
#     "customization": {},
#     "description": "Tender chicken cooked in a rich and creamy tomato-based sauce.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://www.indianveggiedelight.com/wp-content/uploads/2021/08/air-fryer-paneer-tikka-featured.jpg",
#     "name": "Paneer Tikka",
#     "price": 200,
#     "quantity": 3,
#     "veg": 1,
#     "customization": { "mintChutney": 10 },
#     "description": "Marinated and grilled chunks of paneer served with mint chutney.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://www.funfoodfrolic.com/wp-content/uploads/2023/04/Dal-Makhani-Blog.jpg",
#     "name": "Dal Makhani",
#     "price": 250,
#     "quantity": 1,
#     "veg": 0,
#     "customization": { "extraButter": 10 },
#     "description": "Black lentils and kidney beans cooked in a creamy buttery sauce.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://ministryofcurry.com/wp-content/uploads/2017/04/Aloo-Gobi-5.jpg",
#     "name": "Aloo Gobi",
#     "price": 180,
#     "quantity": 2,
#     "veg": 1,
#     "customization": { "extraMasala": 10 },
#     "description": "Potatoes and cauliflower cooked with aromatic spices.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://norecipes.com/wp-content/uploads/2017/05/chicken-biryani-006.jpg",
#     "name": "Chicken Biryani",
#     "price": 350,
#     "quantity": 1,
#     "veg": 2,
#     "customization": { "raita": 20 },
#     "description": "Fragrant basmati rice cooked with succulent chicken and aromatic spices.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://www.kitchensanctuary.com/wp-content/uploads/2021/03/Garlic-Naan-square-FS-42.jpg",
#     "name": "Naan Bread",
#     "price": 50,
#     "quantity": 4,
#     "veg": 1,
#     "customization": { "Garlic Naan": 65 },
#     "description": "Soft and fluffy oven-baked bread with garlic flavor.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://www.indianhealthyrecipes.com/wp-content/uploads/2022/03/bhatura-with-chole.jpg",
#     "name": "Chole Bhature",
#     "price": 220,
#     "quantity": 2,
#     "veg": 1,
#     "customization": { "extraChole": 20 },
#     "description": "Spicy chickpeas served with deep-fried bread, bhature.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "North Indian",
#     "img": "https://static.toiimg.com/thumb/53192600.cms?imgsize=418831&width=800&height=800",
#     "name": "Mutton Rogan Josh",
#     "price": 400,
#     "quantity": 1,
#     "veg": 2,
#     "customization": {},
#     "description": "Tender pieces of mutton slow-cooked in a flavorful and aromatic gravy.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "Beverages",
#     "img": "https://www.indianveggiedelight.com/wp-content/uploads/2023/01/sweet-lassi-recipe-featured.jpg",
#     "name": "Lassi",
#     "price": 200,
#     "quantity": 1,
#     "veg": 1,
#     "customization": {},
#     "description": "Sweet Drink created using milk",
#     "complete": True
#   },
#   {
#     "truckId": "65d091c309914291f8b28dae",
#     "cuisine": "Italian",
#     "img": "https://static.toiimg.com/thumb/56868564.cms?imgsize=1948751&width=800&height=800",
#     "name": "Pizza",
#     "price": 329,
#     "quantity": 2,
#     "veg": 1,
#     "customization": {
#       "tomato": 10,
#       "extra cheese": 20,
#       "olives": 10,
#       "cheese burst": 50
#     },
#     "description": "Classic Italian pizza with tomato sauce, mozzarella cheese, and fresh basil.",
#     "complete": True
#   },
#   {
#     "truckId": "65d091c309914291f8b28dae",
#     "cuisine": "Italian",
#     "img": "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/recipe-image-legacy-id-1001491_11-2e0fa5c.jpg?resize=768,574",
#     "name": "Pasta Carbonara",
#     "price": 290,
#     "quantity": 1,
#     "veg": 2,
#     "customization": {
#       "extra cheese": 20,
#       "flat noodles": 20
#     },
#     "description": "Delicious Italian pasta dish with pancetta, eggs, and Parmesan cheese.",
#     "complete": True
#   },
#   {
#     "truckId": "65d091c309914291f8b28dae",
#     "cuisine": "Mediterranean",
#     "img": "https://www.thehungrybites.com/wp-content/uploads/2017/07/Authentic-Greek-salad-horiatiki-featured.jpg",
#     "name": "Greek Salad",
#     "price": 399,
#     "quantity": 3,
#     "veg": 1,
#     "customization": {
#       "Cucumbers": 10,
#       "Tomatoes": 10,
#       "Olives": 10,
#       "Feta Cheese": 15,
#       "Olive Oil": 20
#     },
#     "description": "Healthy Mediterranean salad with cucumbers, tomatoes, olives, and feta cheese.",
#     "complete": True
#   },
#   {
#     "truckId": "65d091c309914291f8b28dae",
#     "cuisine": "Mediterranean",
#     "img": "https://i.pinimg.com/564x/93/ff/d6/93ffd66e94a33a8d3ad3152501c7cdc5.jpg",
#     "name": "Chicken Shawarma",
#     "price": 149,
#     "quantity": 2,
#     "veg": 2,
#     "customization": {
#       "Garlic Dip": 20
#     },
#     "description": "Grilled chicken shawarma served with garlic tahini sauce in pita bread.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Asian",
#     "img": "https://www.sushiya.in/cdn/shop/files/IMG20230816150632.jpg?v=1692259653",
#     "name": "Sushi Platter",
#     "price": 800,
#     "quantity": 2,
#     "veg": 2,
#     "customization": {},
#     "description": "Assorted sushi selection with various types and flavors.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Asian",
#     "img": "https://lovingitvegan.com/wp-content/uploads/2022/06/Vegan-Pad-Thai-Square-3.jpg",
#     "name": "Pad Thai",
#     "price": 380,
#     "quantity": 3,
#     "veg": 2,
#     "customization": {},
#     "description": "Stir-fried rice noodles with shrimp, tofu, peanuts, and bean sprouts.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Asian",
#     "img": "https://assets.architecturaldigest.in/photos/60083eb9f93542952b665711/4:3/w_1024,h_768,c_limit/ramen-bowl-cody-chan-unsplash-1366x768.jpg",
#     "name": "Ramen Bowl",
#     "price": 450,
#     "quantity": 2,
#     "veg": 2,
#     "customization": { "egg": 20 },
#     "description": "Japanese noodle soup with flavorful broth and assorted toppings.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Chinese",
#     "img": "https://www.kitchensanctuary.com/wp-content/uploads/2019/10/Kung-Pao-Chicken-square-FS-39-new.jpg",
#     "name": "Kung Pao Chicken",
#     "price": 380,
#     "quantity": 2,
#     "veg": 2,
#     "customization": {},
#     "description": "Stir-fried chicken with peanuts, vegetables, and spicy sauce.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Chinese",
#     "img": "https://www.recipetineats.com/wp-content/uploads/2020/08/Sweet-and-Sour-Pork_7-SQ.jpg",
#     "name": "Sweet and Sour Pork",
#     "price": 240,
#     "quantity": 1,
#     "veg": 2,
#     "customization": {},
#     "description": "Crispy pork in a sweet and tangy sauce with pineapple.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Chinese",
#     "img": "https://i.redd.it/0blqosm2qb851.jpg",
#     "name": "Dim Sum Platter",
#     "price": 600,
#     "quantity": 3,
#     "veg": 1,
#     "customization": {},
#     "description": "Assorted Chinese dumplings and spring rolls.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Asian",
#     "img": "https://www.seriouseats.com/thmb/9gYczIvS4R7ZvK19ahBns0xOG_k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20230113-Bibimbap-AmandaSuarez-hero-331e5e1ffa5b400fbb684e59b14d57c1.JPG",
#     "name": "Bibimbap",
#     "price": 360,
#     "quantity": 2,
#     "veg": 2,
#     "customization": {},
#     "description": "Korean mixed rice bowl with vegetables, meat, and spicy sauce.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Chinese",
#     "img": "https://www.recipetineats.com/wp-content/uploads/2020/10/General-Tsao-Chicken_1-SQ.jpg",
#     "name": "General Tso's Chicken",
#     "price": 290,
#     "quantity": 1,
#     "veg": 2,
#     "customization": {},
#     "description": "Deep-fried chicken in a sweet and spicy sauce.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Italian",
#     "img": "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/recipe-image-legacy-id-1001491_11-2e0fa5c.jpg?resize=768,574",
#     "name": "Pasta Carbonara",
#     "price": 350,
#     "quantity": 2,
#     "veg": 2,
#     "customization": { "Smoked Bacon": 20, "Parmesan": 20 },
#     "description": "Creamy pasta with eggs, cheese, and bacon.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Italian",
#     "img": "https://cdn.loveandlemons.com/wp-content/uploads/2023/01/mushroom-risotto.jpg",
#     "name": "Mushroom Risotto",
#     "price": 270,
#     "quantity": 3,
#     "veg": 2,
#     "customization": {},
#     "description": "Creamy Italian risotto with a medley of mushrooms.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Italian",
#     "img": "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2019/07/Caprese-Salad-main-1.jpg",
#     "name": "Caprese Salad",
#     "price": 280,
#     "quantity": 1,
#     "veg": 1,
#     "customization": {
#       "Fresh Mozzarella": 20,
#       "Tomatoes": 10,
#       "Basil": 10
#     },
#     "description": "Classic Italian salad with fresh mozzarella and tomatoes.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Italian",
#     "img": "https://static.toiimg.com/thumb/53351352.cms?imgsize=151967&width=800&height=800",
#     "name": "Vegetarian Pizza",
#     "price": 320,
#     "quantity": 2,
#     "veg": 0,
#     "customization": {
#       "Bell Peppers": 20,
#       "Tomato": 10,
#       "Olives": 20,
#       "Extra Cheese": 20
#     },
#     "description": "Pizza with a variety of colorful vegetables.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Beverages",
#     "img": "https://www.forkinthekitchen.com/wp-content/uploads/2022/07/220629.iced_.latte_.vanilla-8882-500x500.jpg",
#     "name": "Iced Coffee",
#     "price": 220,
#     "quantity": 3,
#     "veg": 0,
#     "customization": { "Whipped Cream": 20 },
#     "description": "Chilled coffee served over ice.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Beverages",
#     "img": "https://cookingformysoul.com/wp-content/uploads/2022/05/triple-berry-smoothie-feat-min-500x500.jpg",
#     "name": "Fruit Smoothie",
#     "price": 150,
#     "quantity": 1,
#     "veg": 0,
#     "customization": {},
#     "description": "Refreshing smoothie with a mix of berries and banana.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Beverages",
#     "img": "https://www.acouplecooks.com/wp-content/uploads/2022/04/Mint-Lemonade-006.jpg",
#     "name": "Mint Lemonade",
#     "price": 230,
#     "quantity": 2,
#     "veg": 0,
#     "customization": {},
#     "description": "Cooling lemonade with a hint of mint.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "Desserts",
#     "img": "https://static.toiimg.com/thumb/63799510.cms?imgsize=1091643&width=800&height=800",
#     "name": "Gulab Jamun",
#     "price": 120,
#     "quantity": 2,
#     "veg": 0,
#     "customization": {},
#     "description": "Deep-fried milk dumplings soaked in rose-flavored sugar syrup.",
#     "complete": True
#   },
#   {
#     "truckId": "65d091c309914291f8b28dae",
#     "cuisine": "Desserts",
#     "img": "https://www.culinaryhill.com/wp-content/uploads/2021/01/Tiramisu-Culinary-Hill-1200x800-1.jpg",
#     "name": "Tiramisu",
#     "price": 180,
#     "quantity": 0,
#     "veg": 1,
#     "customization": {},
#     "description": "Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cheese.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Desserts",
#     "img": "https://cdn.jwplayer.com/v2/media/oaULnCZz/poster.jpg?width=720",
#     "name": "Mango Sticky Rice",
#     "price": 150,
#     "quantity": 2,
#     "veg": 0,
#     "customization": {},
#     "description": "Thai dessert featuring sweet sticky rice topped with ripe mango slices.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Desserts",
#     "img": "https://img.taste.com.au/yDGpfgP1/taste/2020/12/tiramisu-cheesecake-167920-1.jpg",
#     "name": "Tiramisu Cheesecake",
#     "price": 400,
#     "quantity": 1,
#     "veg": 0,
#     "customization": {},
#     "description": "A delightful fusion of tiramisu and cheesecake with a rich coffee flavor.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0921409914291f8b28db3",
#     "cuisine": "Desserts",
#     "img": "https://www.cooking-therapy.com/wp-content/uploads/2020/10/Chinese-Sesame-Balls-4.jpg",
#     "name": "Sesame Balls",
#     "price": 130,
#     "quantity": 3,
#     "veg": 0,
#     "customization": {},
#     "description": "Chinese dessert with crispy sesame-coated balls filled with sweet red bean paste.",
#     "complete": True
#   },
#   {
#     "truckId": "65d0557450f92484fc01221a",
#     "cuisine": "Desserts",
#     "img": "https://www.chitalebandhu.in/cdn/shop/files/Rasgulla-Image-_3_1024x1024.jpg?v=1697398551",
#     "name": "Rasgulla",
#     "price": 110,
#     "quantity": 2,
#     "veg": 0,
#     "customization": {},
#     "description": "Soft and spongy Indian dessert dumplings in saffron-infused sugar syrup.",
#     "complete": True
#   },
#   {
#     "truckId": "65d092cb09914291f8b28db8",
#     "cuisine": "Desserts",
#     "img": "https://www.cuisinart.com/globalassets/recipes/recipe_11315_1710701127.jpg",
#     "name": "Mixed Berry Gelato",
#     "price": 160,
#     "quantity": 2,
#     "veg": 0,
#     "customization": {},
#     "description": "Refreshing Italian frozen dessert with a mix of berries.",
#     "complete": True
#   },
#   {
#     "truckId": "65d091c309914291f8b28dae",
#     "cuisine": "Desserts",
#     "img": "https://www.sipandfeast.com/wp-content/uploads/2022/11/cannoli-recipe-snippet.jpg",
#     "name": "Cannoli",
#     "price": 190,
#     "quantity": 1,
#     "veg": 0,
#     "customization": {},
#     "description": "Sicilian pastry tubes filled with sweet ricotta and chocolate chips.",
#     "complete": True
#   }
# ]


# for item in data:
#     item["truckId"] = ObjectId(item["truckId"])
#     x = menu_collection.insert_one(item)
#     print(item["name"])