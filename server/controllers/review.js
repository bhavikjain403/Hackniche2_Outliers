const Review = require("../models/review");
const Admin = require("../models/admin");

const addReview = async (req,res) => {
    try {
        var newReview = new Review({
            ...req.body
        })
        await newReview.save()
        var rating = req.body.rating
        var data = await Admin.findById(req.body.adminId)
        data = data
        var oldRating = data['rating']
        var count = data['numberOfRatings']+1
        var newRating = ((oldRating*count)+rating)/count
        await Admin.findByIdAndUpdate(req.body.adminId, {rating:newRating, numberOfRatings:count})
        res.status(201).json({
            message: "Review added successfully!",
            status: true
          });
    }
    catch (err) {
        res.status(400).json({
          message: err.message,
          status: false
        });
     }
}

const getReviewByTruck = async (req,res) => {
    try {
        var adminId = req.query.truckId
        var review = await Review.find({adminId}).sort({date:-1})
        if(review.length>0) {
            res.status(200).json({
                message: "You have the following reviews!",
                status: true,
                data: review,
              });
        }
        else {
            res.status(400).json({
              message: "No reviews available !",
              status: false,
              data: {},
            });
          }
    }
    catch (err) {
        res.status(400).json({
          message: err.message,
          status: false
        });
     }
}

const getReviewByUser = async (req,res) => {
    try {
        var userId = req.query.userId
        var review = await Review.find({userId}).sort({date:-1})
        if(review.length>0) {
            res.status(200).json({
                message: "You have the following reviews!",
                status: true,
                data: review,
              });
        }
        else {
            res.status(400).json({
              message: "No reviews available !",
              status: false,
              data: {},
            });
          }
    }
    catch (err) {
        res.status(400).json({
          message: err.message,
          status: false
        });
     }
}

const getReviewByOrder = async (req,res) => {
  try {
      var orderId = req.query.orderId
      var review = await Review.find({orderId}).sort({date:-1})
      if(review.length>0) {
          res.status(200).json({
              message: "You have the following reviews!",
              status: true,
              data: review,
            });
      }
      else {
          res.status(400).json({
            message: "No reviews available !",
            status: false,
            data: {},
          });
        }
  }
  catch (err) {
      res.status(400).json({
        message: err.message,
        status: false
      });
   }
}

module.exports = {
  addReview,
  getReviewByTruck,
  getReviewByUser,
  getReviewByOrder
};