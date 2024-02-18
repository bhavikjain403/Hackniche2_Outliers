const Menu = require("../models/menu");

const addItem = async (req,res) => {
    try {
        var newMenu = new Menu({
            ...req.body
        })
        await newMenu.save()
        res.status(201).json({
            message: "Item added!",
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

const bulkAddItem = async (req,res) => {
  try {
    var data = req.body
    for(let i=0;i<data.length;i++) {
      var newMenu = new Menu({
          ...data[i]
      })
      await newMenu.save()
    }
      res.status(201).json({
          message: "Item added!",
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

const updateItem = async (req,res) => {
    try {
        var id = req.body._id
        await Menu.findByIdAndUpdate(id, req.body)
        res.status(201).json({
            message: "Item updated!",
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

const getMenuByCuisine = async (req,res) => {
    try {
        var cuisine = req.query.cuisine
        var menu = await Menu.find({cuisine: cuisine})
        if(menu.length>0) {
            res.status(200).json({
                message: "You have the following items!",
                status: true,
                data: menu,
              });
        }
        else {
            res.status(400).json({
              message: "No items available !",
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

const getFoodByName = async (req,res) => {
    try {
        var name = req.query.name
        var menu = await Menu.find({"name": { "$regex": name, "$options": "i" }})
        if(menu.length>0) {
            res.status(200).json({
                message: "You have the following items!",
                status: true,
                data: menu,
              });
        }
        else {
            res.status(400).json({
              message: "No items available !",
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

const getMenuByTruck = async (req,res) => {
  try {
      var truckId = req.query.id
      var menu = await Menu.find({truckId})
      if(menu.length>0) {
          res.status(200).json({
              message: "You have the following items!",
              status: true,
              data: menu,
            });
      }
      else {
          res.status(400).json({
            message: "No items available !",
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

const deleteItem = async (req,res) => {
  try {
      var id = req.query.id
      await Menu.findByIdAndDelete(id)
      res.status(200).json({
          message: "Item deleted!",
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

module.exports = {
    addItem,
    getMenuByCuisine,
    updateItem,
    getFoodByName,
    getMenuByTruck,
    deleteItem,
    bulkAddItem
};