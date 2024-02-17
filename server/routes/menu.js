// Importing modules
const express = require("express");
// Importing controllers and utilities
const {
  addItem,
  getMenuByCuisine,
  updateItem,
  getFoodByName,
  getMenuByTruck,
  deleteItem
} = require("../controllers/menu");

// Initializing router
const router = new express.Router();

router.post("/additem", addItem);
router.post("/updateitem", updateItem);
router.get("/getmenubycuisine", getMenuByCuisine);
router.get("/getfoodbyname", getFoodByName);
router.get("/getMenuByTruck", getMenuByTruck);
router.get("/deleteItem", deleteItem);
// Exporting Modules
module.exports = router;
