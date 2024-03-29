import { connect } from 'mongoose';

const dbUri = process.env.MONGO_DB_URL;

export async function connectToDb(succes,failure) {
    connect(dbUri, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    }).then(() => {
        console.log("Connection Successful");
        succes();
    }).catch((e) => {
        failure(e);
        console.log("No connection" + e);
    });
}