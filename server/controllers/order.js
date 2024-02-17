const Order = require("../models/order");
const Menu = require("../models/menu");

const addOrder = async (req,res) => {
    try {
        var newOrder = new Order({
            ...req.body
        })
        await newOrder.save()
        var items = req.body.items
        for(let i=0; i<items.length; i++) {
          var id=items[i].itemid
          var data = await Menu.findById(id)
          data = data
          var prefix = data["quantity"]
          await Menu.findByIdAndUpdate(id, {quantity : prefix - items[i].quantity})
        }
        res.status(201).json({
            message: "Order placed successfully!",
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

const updateOrder = async (req,res) => {
    try {
        var id = req.body._id
        await Order.findByIdAndUpdate(id, req.body)
        res.status(201).json({
            message: "Order updated!",
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