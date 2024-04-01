const util = require("util");
const msgStatus = require("../constants/messageStatus");
const messageController = require("../controllers/messageController");
const PrivateMessageModel = require("../models/privateMessage");
const isUserOne = require("../utils/appUtils");
const pushNotificationService = require("../services/pushNotificationService");
const userModel = require("../models/user");

let io;
let socketConnection;

function emitUserStatus(userId,userStatus){
    io.emit(userId+"_status", userStatus);
}

const socketConnected = (userId) => {
    const connectionStatusChangeData = {
        userId: userId,
        isOnline: true,
    };
    socketConnection.broadcast.emit(
        userId + "_status",
        connectionStatusChangeData.isOnline
    );
    messageController.getMissedMessage(userId);
    messageController.getMissedRecentChatUpdate(userId);
};

const socketDisConnected = (userId) => {
    console.log(`-------------------- USER with : ${userId} is OFFLINE-------------------`);
    emitUserStatus(userId,false);
};

const emitAddRecentChatEvent = (exports.emitAddRecentChatEvent = (receiverId, recentChat) => {
    io.to(receiverId).emit("newRecentChat", recentChat);
});

const emitPrivateMessageEvent = (exports.emitPrivateMessageEvent = (
    roomId,
    message
) => {
    io.to(roomId).emit("newPrivateMessage", message);
});

const emitUpdateExistingMessageEvent = (exports.emitUpdateExistingMessageEvent =
    ({
         roomId,
         msgId,
         status,
         seenAt = null,
         deliveredAt = null,
         withAcknowledgeApi = false,
     } = {}) => {
        let message = {
            msg_status: status,
            _id: msgId,
        };

        if (seenAt != null && deliveredAt != null) {
            status = msgStatus.seen;
            message = {
                msg_status: status,
                _id: msgId,
                delivered_at: deliveredAt,
                seen_at: seenAt,
            };
        } else if (seenAt != null) {
            status = msgStatus.seen;
            message = {
                msg_status: status,
                _id: msgId,
                seen_at: seenAt,
            };
        } else if (deliveredAt != null) {
            status = msgStatus.delivered;
            message = {
                msg_status: status,
                _id: msgId,
                delivered_at: deliveredAt,
            };
        }

        if (withAcknowledgeApi) {
            io.to(roomId).emit("updateExistingMessageWithAcknowledgeApi", message);
        } else {
            io.to(roomId).emit("updateExistingMessage", message);
        }
    });

function listenToEvents(socket, userId) {
    socket.on("newPrivateMessage", async (data, callback) => {
        const privateMessageModel = data.privateMessageModel;
        const recentChatModel = data.recentChatModel;

        const senderId = privateMessageModel.sender_id;
        const receiverId = privateMessageModel.receiver_id;
        const listOfParticipants = [senderId, receiverId];
        listOfParticipants.sort();

        const senderIsUserOne = isUserOne(listOfParticipants, senderId);

        try {
            callback();

            if (!recentChatModel.should_update_recent_chat) {
                await messageController.addToRecentChat(
                    recentChatModel,
                    senderIsUserOne
                );
                emitAddRecentChatEvent(receiverId, recentChatModel);
            }

            emitPrivateMessageEvent(receiverId, privateMessageModel);
            await PrivateMessageModel.create(privateMessageModel);

            // send push notification
            const receiverInfo = await userModel.findById(receiverId);
            const message = {
                data: {
                    id: senderId,
                    title: recentChatModel.user1_name,
                    body: privateMessageModel.msg_content,
                    image: privateMessageModel.network_file_url ?? "",
                },
                token: receiverInfo.firebase_token_id,
            };
            await pushNotificationService.sendPushNotification(message);
        } catch (error) {
        }
    });

    socket.on("updatePrivateMessage", async (data, callback) => {
        try {
            callback();
            const msgId = data._id;
            const msgSeenTime = data.seen_at;
            const msgDeliverTime = data.delivered_at;

            const senderId = data.sender_id;

            emitUpdateExistingMessageEvent({
                msgId: msgId,
                seenAt: msgSeenTime,
                deliveredAt: msgDeliverTime,
                roomId: senderId,
                withAcknowledgeApi: true,
            });

            await PrivateMessageModel.findByIdAndUpdate(
                msgId,
                {
                    seen_at: msgSeenTime,
                    deliveredAt: msgDeliverTime,
                    msg_status:
                        msgSeenTime != null ? msgStatus.seen : msgStatus.delivered,
                    sender_local_updated: false,
                    receiver_local_updated: true,
                },
                { runValidators: true }
            );
        } catch (error) {
            console.log("updateMessage " + "Error :- " + error);
        }
    });

    socket.on("userStatus", (data) => {
        const userId = data.id;
        const userStatus = data.userStatus;
        emitUserStatus(userId,userStatus);
    });

    socket.on("typing", (data) => {
        const receiverId = data.id;
        const isTyping = data.isTyping;
        io.to(receiverId).emit("typing", isTyping);
    });

    socket.on("disconnect", () => {
        socketDisConnected(userId);
        socket.leave(userId);
    });
}

exports.makeSocketConnection = (server) => {
    io = require("socket.io")(server);

    io.on("connection", async (socket) => {
        const userId = socket.handshake.query.userId;
        console.log(`-------------------- USER CONNECTED WITH USERID : ${userId} -------------------`);
        socket.join(userId);
        socketConnection = socket;

        socketConnected(userId);
        listenToEvents(socket, userId);
    });
};

exports.emitUpdateRecentChatEvent = (roomId, recentChat) => {
    io.to(roomId).emit("updateRecentChat", recentChat);
};

exports.getRooms = () => io.sockets.adapter.rooms;
