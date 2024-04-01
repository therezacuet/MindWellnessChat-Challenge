const express = require("express");
const userRoutes = require("./user");
const messageRoutes = require("./message");

const apiRouter = express.Router();

// User
apiRouter.use("/users", userRoutes);

// Message
apiRouter.use("/messages", messageRoutes);

module.exports = apiRouter;
