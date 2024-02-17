// Importing modules
const mongoose = require("mongoose");

// Creating the schema
const reviewSchema = new mongoose.Schema(
  {
    userId: {
        type: ObjectId,
        ref: 'User'
    },

    adminId: {
        type: ObjectId,
        ref: 'Admin'
    },

    rating: Number,

    review: String
  }
);

const Review = mongoose.model("Review", reviewSchema);

// Exporting the module
module.exports = Review;
