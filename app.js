import express from "express";
import morgan from "morgan";
import { config } from "dotenv";
import database from "./configs/dbConnection";
import process from "node:process";
import initializeFirebase from "./configs/firebaseInit";
import userRoutes from "routers/user";
import messageRoutes from "routers/message";
import {makeSocketConnection} from "./services/socketService";
import customResponses from "helpers/customResponses";
import decodeIDToken from "middlewares/tokenVerification";

config({path: "config.env"});

// Define the port number
const PORT = process.env.PORT || 5000;

// Initialize the express app
const app = express();
const server = require("http").createServer(app);

// Config logger middleware
app.use(morgan("dev"));
app.use(express.urlencoded());
app.use(express.json());
app.use(morgan("combined"));

// Define the routes
app.use("/users", userRoutes);
app.use("/messages", messageRoutes);

// Custom response middleware
app.use(customResponses);
app.use(decodeIDToken);

app.use((req, res) => {
    res.serverError();
});

// Initialize the firebase
initializeFirebase();

// Import the database connection
database.connectToDb(() => {
      makeSocketConnection(server);
      server.listen(PORT, () => {
        console.log("Server Started");
      });
    },() => {
      console.log("Database connection failed");
    }
);

// Error handling middleware
app.use((err, req, res, next) => {
    err.statusCode = err.statusCode || 500;
    const className = err.constructor.name;
    console.log("err.message :- " + err.message);
    if (className == "BaseError") {
      res.customizedErrorOutPut(err.message, err.statusCode);
    } else {
      //Error thrown by mongoose validation
      if (err.name === "ValidationError") {
        res.validationError({ message: err.message });
      } else {
        res.serverError({ message: err.message });
      }
    }
});
