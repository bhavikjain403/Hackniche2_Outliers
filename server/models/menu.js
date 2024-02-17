// Importing modules
const mongoose = require("mongoose");

// Creating the schema
const menuSchema = new mongoose.Schema(
  {
    truckId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Admin'
    },
    cuisine: {
        type: String,
        enum: ['North Indian' , 'Chinese' , 'Continental' , 'Asian' , 'Italian' , 'Beverages', 'Desserts']
    },
    img: String,
    name: String,
    price: Number,
    quantity: Number,
    veg: {
        type: Number,
        enum: [0,1,2]
    },
    customization: {},
    description: String,
    complete: {
        type: Boolean,
        default: true
    }
}
);

const Menu = mongoose.model("Menu", menuSchema);

// Exporting the module
module.exports = Menu;
