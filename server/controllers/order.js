const Order = require("../models/order");

const addOrder = async (req,res) => {
    try {
        var newOrder = new Order({
            ...req.body
        })
        await newOrder.save()
        res.status(201).json({
            message: "Order placed successfully!"
          });
    }
    catch (err) {
        res.status(400).json({
          message: err.message,
          status: false
        });
     }
}

const updateOrder = async (req,res) => {
    try {
        var id = req.body._id
        await Order.findByIdAndUpdate(id, req.body)
        res.status(201).json({
            message: "Order updated!"
          });
    }
    catch (err) {
        res.status(400).json({
          message: err.message,
          status: false
        });
     }
}

const getOrderByTruck = async (req,res) => {
    try {
        var adminId = req.query.truckId
        var order = await Order.find({adminId}).sort({placedTime:-1})
        if(order.length>0) {
            res.status(200).json({
                message: "You have the following orders!",
                status: true,
                data: order,
              });
        }
        else {
            res.status(400).json({
              message: "No orders available !",
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

const getOrderByUser = async (req,res) => {
    try {
        var userId = req.query.userId
        var order = await Order.find({userId}).sort({placedTime:-1})
        if(order.length>0) {
            res.status(200).json({
                message: "You have the following orders!",
                status: true,
                data: order,
              });
        }
        else {
            res.status(400).json({
              message: "No orders available !",
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
    addOrder,
    updateOrder,
    getOrderByTruck,
    getOrderByUser
};