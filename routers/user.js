const express = require("express");
const userController = require("../controllers/userController");
const router = express.Router();

router.post("/", userController.addUser);
router.patch("/", userController.updateUser);
router.get("/", userController.getSingleUser);
router.get("/search/", userController.searchSingleUser);
router.patch("/userUpdateToken/", userController.updateUserToken);
router.get("/getBackupDetails/", userController.getUserBackUpDetails);
router.get("/userBackUpData/", userController.getUserBackUpData);
router.get("/userConnectionStatus", userController.getUserConnectionStatus);

module.exports = router;
