import { connect } from 'mongoose';

const dbUri = process.env.MONGO_DB_URL;

export async function connectToDb(success,failure) {
    connect(dbUri, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    }).then(() => {
        console.log("Connection Successful");
        success();
    }).catch((e) => {
        failure(e);
        console.log("No connection" + e);
    });
}
