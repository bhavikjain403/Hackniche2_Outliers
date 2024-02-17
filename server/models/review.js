// Importing modules
const mongoose = require("mongoose");

// Creating the schema
const reviewSchema = new mongoose.Schema(
  {
    userId: {
        type: mongoose.Schema.ObjectId,
        ref: 'User'
    },

    adminId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Admin'
    },

    orderId: {
      type: mongoose.Schema.ObjectId,
      ref: 'Order'
    },

    rating: Number,

    review: String,

    date: {
      type: Date,
      default: Date.now()
    }
  }
);

const Review = mongoose.model("Review", reviewSchema);

// Exporting the module
module.exports = Review;
