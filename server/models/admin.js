// Importing modules
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// Creating the schema
const adminSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },

    email: {
      type: String,
      required: true,
      trim: true,
      unique: true,
      lowercase: true,
      match: [
        /^\w+([.-]?\w+)@\w+([.-]?\w+)(.\w{2,3})+$/,
        "Invalid email address!",
      ],
    },

    phone: {
      type: Number,
      trim: true,
    },

    password: {
      type: String,
      required: true,
      trim: true,
      minlength: [4, "Password too short!"],
      maxlength: [128, "Password too long!"],
    },

    latitude: {
        type: Number
    },

    longitude: {
        type: Number
    },

    place: String,

    rating: {
        type: Number,
        default: 4
    },

    numberOfRatings: {
        type: Number,
        default: 100
    },

    cuisine: [],

    city: String,

    img: String,

    routeMarker: []
  }
);

// Hashing the password
adminSchema.pre("save", async function (next) {
  let currentUser = this;
  if (!currentUser.isModified("password")) {
    return next();
  }
  try {
    const salt = await bcrypt.genSalt(10);
    currentUser.password = await bcrypt.hash(currentUser.password, salt);
    return next();
  } catch (error) {
    return next(error);
  }
});

// Generating jwt
adminSchema.statics.generatejwt = async (userid) => {
  const user = await Admin.findById(userid);
  const token = jwt.sign({ _id: user._id.toString() }, process.env.JWT_SECRET, {
    expiresIn: "24h",
  });
 // user.tokens = user.tokens.concat({ token });
  await user.save();
  return token;
};

const Admin = mongoose.model("Admin", adminSchema);

// Exporting the module
module.exports = Admin;
