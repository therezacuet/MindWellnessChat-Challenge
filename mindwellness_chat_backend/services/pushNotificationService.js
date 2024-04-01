
const admin = require('firebase-admin');
const sendPushNotification = async (message) => {
    try {
        await admin.messaging().send(message);
    } catch (error) {
        console.log('Error sending message:', error);
    }
};

module.exports = {
    sendPushNotification,
};
