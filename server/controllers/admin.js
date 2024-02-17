// Importing modules
const Admin = require("../models/admin");
const bcryptjs = require("bcryptjs");
const { removeSensitiveData, getRegion } = require("../utils/functions");

// Signup
const signup = async (req, res) => {
  try {
    let admin = await Admin.findOne({ email: req.body.email });
    if (admin) {
      res.status(400).json({
        message: "Admin Already Exists!",
        data: {
            admin: admin,
        },
      });
      return;
    }

    const city = await getRegion(req.body)

    let newAdmin = new Admin({
      ...req.body,
      city: city
    });
    await newAdmin.save();
    const token = await Admin.generatejwt(newAdmin._id);

    newAdmin = removeSensitiveData(newAdmin);
    // Sending a response back
    res.status(201).json({
      message: "Admin Signed Up",
      data: {
        token,
        admin: newAdmin,
      },
    });
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
};

// Login
const login = async (req, res) => {
  try {
    let admin = await Admin.findOne({ email: req.body.email });

    if (!admin) {
      res.status(404).json({
        status: false,
        data: {},
        message: "Admin not found!",
      });
      return;
    }

    const isMatch = await bcryptjs.compare(req.body.password, admin.password);

    if (!isMatch) {
      res.status(401).json({
        status: false,
        data: {},
        message: "Invalid credentials!",

      });
      return;
    }

    const token = await Admin.generatejwt(admin._id);

    admin = removeSensitiveData(admin);

    res.status(200).json({
      status: false,
      data: {
        token,
        admin
      },
      message: "Admin Verified!",

    });
  } catch (error) {
    res.status(400).json({
      message: error.message,
      status: false,
      data: {

      },
    });
  }
};

// Logout
const logout = async (req, res) => {
  try {
    const currentAdmin = req.admin;
    const token = req.token;

    currentAdmin.tokens = currentAdmin.tokens.filter((admintoken) => {
      return admintoken.token !== token;
    });

    await currentAdmin.save();

    res.status(200).json({
      message: "Successfully logged out!",
    });
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
};

const getTruckByName = async (req,res) => {
    try {
        var name = req.query.name
        var truck = await Admin.find({"name": { "$regex": name, "$options": "i" }})
        if(truck.length>0) {
            res.status(200).json({
                message: "You have the following trucks!",
                status: true,
                data: truck,
              });
        }
        else {
            res.status(400).json({
              message: "No trucks available !",
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

// Exporting modules
module.exports = {
  signup,
  login,
  logout,
  getTruckByName
};
