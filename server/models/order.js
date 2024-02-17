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

    placedTime: Date,

    pickupTime: Date,

    accepted: {
        type: String,
        enum: ['yes', 'no']
    },

    orderStatus: {
        type: String,
        enum: ['placed', 'preparing', 'picked'],
        default: 'placed'
    },

    items: {}
  }
);

const Order = mongoose.model("Order", orderSchema);

// Exporting the module
module.exports = Order;
