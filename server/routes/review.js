// Importing modules
const express = require("express");
// Importing controllers and utilities
const {
    addReview,
  getReviewByTruck,
  getReviewByUser,
  getReviewByOrder
} = require("../controllers/review");

// Initializing router
const router = new express.Router();

router.post("/addReview", addReview);
router.get("/getReviewByTruck", getReviewByTruck);
router.get("/getReviewByUser", getReviewByUser);
router.get("/getReviewByOrder", getReviewByOrder);
// Exporting Modules
module.exports = router;
