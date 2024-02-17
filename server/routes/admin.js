// Importing modules
const express = require("express");
// Importing Middleware
const authorizeJWT = require("../middleware/jwt");
// Importing controllers and utilities
const {
  signup,
  login,
  logout,
  getTruckByName,
  getNearbyTrucks,
  getTruckFromId,
  deleteTruck,
  addRouteMarker
} = require("../controllers/admin");

// Initializing router
const router = new express.Router();

router.post("/signup", signup);
router.post("/login", login);
router.post("/addRouteMarker", addRouteMarker);
router.get("/gettruckbyname", getTruckByName);
router.get("/getNearbyTrucks", getNearbyTrucks);
router.get("/getTruckFromId", getTruckFromId);
router.get("/deleteTruck", deleteTruck);
router.put("/logout", authorizeJWT.verifyJWT, logout);
// Exporting Modules
module.exports = router;
