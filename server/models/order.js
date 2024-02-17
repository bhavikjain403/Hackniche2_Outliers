// Importing modules
const mongoose = require("mongoose");

// Creating the schema
const orderSchema = new mongoose.Schema(
  {
    userId: {
        type: mongoose.Schema.ObjectId,
        ref: 'User'
    },

    adminId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Admin'
    },

    paymentMode: {
        type: String,
        enum: ['cod', 'prepaid']
    },

    amount: Number,

    placedTime: 
    {
        type: Date,
        default: Date.now()
    },

    scheduledTime: [],

    pickupTime: Date,

    accepted: {
        type: String,
        enum: ['yes', 'no']
    },

    orderStatus: {
        type: String,
        enum: ['placed', 'preordered', 'preparing', 'picked'],
        default: 'placed'
    },

    items: []
  }
);

const Order = mongoose.model("Order", orderSchema);

// Exporting the module
module.exports = Order;
