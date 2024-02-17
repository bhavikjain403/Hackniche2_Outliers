// Importing modules
const mongoose = require("mongoose");

// Creating the schema
const menuSchema = new mongoose.Schema(
  {
    foodItems: [
        {
            cuisine: {
                type: String,
                enum: ['North Indian' , 'Chinese' , 'Continental' , 'Asian' , 'Italian' , 'Beverages', 'Desserts']
            },
            items: [
                {
                    truckId: {
                        type: ObjectId,
                        ref: 'Admin'
                    },
                    img: String,
                    name: String,
                    price: Number,
                    available: {
                        type: String,
                        enum: ['yes', 'no'],
                        default: 'yes'
                    },
                    veg: {
                        type: Number,
                        enum: [0,1,2]
                    },
                    customization: {},
                    description: String
                }
            ]
        }
    ]
  }
);

const Menu = mongoose.model("Menu", menuSchema);

// Exporting the module
module.exports = Menu;
