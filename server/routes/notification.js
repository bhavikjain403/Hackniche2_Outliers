// Importing modules
const express = require("express");
// Importing controllers and utilities
const {
    sendNotification
} = require("../controllers/notification");

// Initializing router
const router = new express.Router();

router.post("/sendNotification", sendNotification);
// Exporting Modules
module.exports = router;
