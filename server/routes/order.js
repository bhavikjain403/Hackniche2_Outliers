// Importing modules
const express = require("express");
// Importing controllers and utilities
const {
    addOrder,
    updateOrder,
    getOrderByTruck,
    getOrderByUser
} = require("../controllers/order");

// Initializing router
const router = new express.Router();

router.post("/addOrder", addOrder);
router.post("/updateOrder", updateOrder);
router.get("/getOrderByTruck", getOrderByTruck);
router.get("/getOrderByUser", getOrderByUser);
// Exporting Modules
module.exports = router;
