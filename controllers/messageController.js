const util = require("util");
const msgStatus = require( "../constants/messageStatus");
const RecentChatModel = require( "../models/recentChat");
const PrivateMessageModel = require( "../models/privateMessage");

const socketService = require("../services/socketService");

exports.addToRecentChat = async (recentChatModel, isUser1) => {
    console.log(
        "INCREMENT ID ! - " + util.inspect(recentChatModel, { depth: null })
    );
    try {
        recentChatModel.user1_local_updated = true;
        recentChatModel.user2_local_updated = true;
        await RecentChatModel.create(recentChatModel);
    } catch (e) {
        console.log("Recent chat add error- " + e);
    }
};

exports.updateRecentMessage = async (req,res,next) => {
    const updateObj = req.body;
    const _id = req.body._id;
    delete updateObj["_id"];
    console.log("eq.body :- " + util.inspect(updateObj));
    console.log("eq.body :- " +req.body._id);
    try {
        await RecentChatModel.findByIdAndUpdate(_id, updateObj);
        res.dataUpdateSuccess({ message: "Message Created Successfully" });
    } catch (e) {
        next(e);
    }
};

exports.getMissedMessage = async (userId) => {
    console.log(`-------------------- GETTING MISSED MESSAGE FOR : ${userId} -------------------`);

    try {
        const foundUpdatedMessages = await PrivateMessageModel.find({
            $and: [{ sender_id: userId }, { sender_local_updated: false }],
        });

        const foundNewMessages = await PrivateMessageModel.find({
            $and: [{ receiver_id: userId }, { msg_status: msgStatus.sent }],
        });

        console.log(`-------------------- FOUND MESSAGES FOR : ${userId} :: NEW : ${foundNewMessages.length}  :: UPDATED : ${foundUpdatedMessages.length} -------------------`);

        for (const message of foundUpdatedMessages) {

            socketService.emitUpdateExistingMessageEvent({
                msgId: message._id,
                roomId: userId,
                seenAt: message.seen_at,
                deliveredAt: message.delivered_at,
                withAcknowledgeApi: true,
                status: message.msg_status,
            });
        }

        for (const message of foundNewMessages) {
            const participantToSearchFor = [message.participants.user1_id,message.participants.user2_id];
            participantToSearchFor.sort();
            const foundRecentChat = await RecentChatModel.find({
                "participants": participantToSearchFor,
            });


            if (message.should_update_recent_chat) {
                socketService.emitAddRecentChatEvent(userId,foundRecentChat[0]);
            }

            socketService.emitPrivateMessageEvent(userId, message);

        }

    } catch (error) {
        console.log("ERROR OCCURRED :- " + error);
    }
};

exports.getMissedRecentChatUpdate = async (userId) => {
    console.log(  `-------------------- GETTING MISSED RECENT CHAT UPDATE MESSAGE FOR : ${userId} -------------------`);

    try {
        let aggregationQuery = [
            {
                '$match': {
                    'participants': userId
                }
            }, {
                '$addFields': {
                    'matchedIndex': {
                        '$indexOfArray': [
                            '$participants', userId
                        ]
                    }
                }
            }, {
                '$match': {
                    '$or': [
                        {
                            '$and': [
                                {
                                    'matchedIndex': 1
                                }, {
                                    'user1_local_updated': true
                                }
                            ]
                        }, {
                            '$and': [
                                {
                                    'matchedIndex': 0
                                }, {
                                    'user2_local_updated': true
                                }
                            ]
                        }
                    ]
                }
            }
        ];

        const results = await RecentChatModel.aggregate(aggregationQuery);
        results.forEach(async function(x){
            console.log("FOUND :- " + util.inspect(x));
            socketService.emitAddRecentChatEvent(userId,x);
        });

    } catch (error) {
        console.log("ERROR OCCURRED in GETTING MISSED RECENT CHAT UPDATE MESSAGE :- " + error);
    }
};

exports.updateMsgDeliverTime = async (req, res, next) => {
    try {
        const msgDeliverTime = req.body.delivered_at;
        const msgId = req.body._id;
        const senderId = req.body.sender_id;

        socketService.emitUpdateExistingMessageEvent({
            msgId: msgId,
            roomId: senderId,
            status: msgStatus.delivered,
            deliveredAt: msgDeliverTime,
            withAcknowledgeApi: true,
        });

        await PrivateMessageModel.findByIdAndUpdate(
            msgId,
            {
                msg_status: msgStatus.delivered,
                delivered_at: msgDeliverTime,
                sender_local_updated: false,
                receiver_local_updated: true,
            },
            { runValidators: true }
        );

        res.dataUpdateSuccess();
    } catch (error) {
        next(error);
    }
};

exports.updateMsgSeenTime = async (req, res, next) => {
    console.log("getting error :- ");
    try {
        const msgId = req.body._id;
        const msgSeenTime = req.body.seen_at;
        const senderId = req.body.sender_id;

        socketService.emitUpdateExistingMessageEvent({
            msgId: msgId,
            roomId: senderId,
            status: msgStatus.seen,
            seenAt: msgSeenTime,
            withAcknowledgeApi: true,
        });
        await PrivateMessageModel.findByIdAndUpdate(
            msgId,
            {
                msg_status: msgStatus.seen,
                seen_at: msgSeenTime,
                sender_local_updated: false,
                receiver_local_updated: true,
            },
            { runValidators: true }
        );

        res.dataUpdateSuccess();
    } catch (error) {
        console.log("error :- " + error);
        next(error);
    }
};

exports.msgUpdatedLocallyForSender = async (req, res, next) => {
    try {
        const msgId = req.body._id;
        await PrivateMessageModel.findByIdAndUpdate(
            msgId,
            { sender_local_updated: true },
            { runValidators: true }
        );
        res.dataUpdateSuccess();
    } catch (error) {
        console.log("error :- " + error);
        next(error);
    }
};
