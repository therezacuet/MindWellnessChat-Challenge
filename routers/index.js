const express = require("express");
const userRoutes = require("./user");
const messageRoutes = require("./message");

const apiRouter = express.Router();

/* GET home page. */
apiRouter.get("/", function (req, res, next) {
    res.send("Server is running");
});

// User
apiRouter.use("/users", userRoutes);

// Message
apiRouter.use("/messages", messageRoutes);

module.exports = apiRouter;
