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

    rating: Number,

    review: String
  }
);

const Review = mongoose.model("Review", reviewSchema);

// Exporting the module
module.exports = Review;
