const admin = require('firebase-admin');
const errorResponse = require("../helpers/errors/errorResponse");
async function decodeIDToken(req, res, next) {
    const header = req.headers?.authorization;
    if (header !== 'Bearer null' && req.headers?.authorization?.startsWith('Bearer ')) {
        const idToken = req.headers.authorization.split('Bearer ')[1];
        const userId = req.headers.userid;
        try {
            req['authorization'] = await admin.auth().verifyIdToken(idToken);
            req['userId'] = userId;
            next();
        } catch (error) {
            next(error);
        }
    }else{
        next(errorResponse.idNotFoundError());
    }
}
module.exports = decodeIDToken;
