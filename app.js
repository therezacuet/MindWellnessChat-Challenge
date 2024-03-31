const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
const process = require("process");
dotenv.config({path: "config.env"});

const database = require("./configs/dbConnection");
const initializeFirebase = require("./configs/firebaseInit");
const apiRouter = require( "./routers/index");
const {makeSocketConnection} = require( "./services/socketService");
const customResponses = require( "./helpers/customResponses");
const decodeIDToken = require( "./middlewares/tokenVerification");

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

// Initialize the firebase
initializeFirebase();

// Custom response middleware
app.use(customResponses);

// Define the routes
app.use("/api/v1", apiRouter);

app.use(decodeIDToken);

app.use((req, res) => {
    res.serverError();
});

// database connection
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
    if (className === "BaseError") {
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
