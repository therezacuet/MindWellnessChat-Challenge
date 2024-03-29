const mongoose = require('mongoose');

const dbUri = process.env.MONGO_DB_URL;

exports.connectToDb = async (success,failure) => {
    mongoose.connect(dbUri, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    }).then(() => {
        console.log("Connection Successful");
        success();
    }).catch((e) => {
            failure(e);
            console.log("No connection" + e);
        }
    );
};
