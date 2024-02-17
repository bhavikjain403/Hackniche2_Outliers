// Importing modules
const express = require("express");
const cors = require("cors");
const db = require("./connection");


// Initializing an express app
const app = express();

// Server Port
const PORT = process.env.PORT || 5001;

// Formatting incoming data and allowing cross origin requests
app.use(cors({origin: true}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));



// Importing Routes
const userRoute = require("./routes/user");
const adminRoute = require("./routes/admin");


// Routes
app.use("/api/user", userRoute);
app.use("/api/admin", adminRoute);


app.get("/api", (req, res) => {
  res.json({ message: "Server is running!" });
});

// Error Handling for Multer
// app.use((error, req, res, next) => {
//   console.log('This is the rejected field ->', error.field);
// });

// Listening on the port
app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});
