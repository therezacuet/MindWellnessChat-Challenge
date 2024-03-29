import { Schema, model as _model } from 'mongoose';

const recentChatSchema = new Schema({
    _id:{
        type:String
    },
    user1_name:{
        type:String,
        required:true,
    },
    user1_compressed_image:{
        type:String,
        default:null,
    },
    user2_name:{
        type:String,
        required:true,
    },
    user2_compressed_image:{
        type:String,
        default:null,
    },
    participants:{
        type:[String]
    },
    user1_local_updated:{
        type:Boolean,
        default:false
    },
    user2_local_updated:{
        type:Boolean,
        default:false
    }
});

const model = _model('recentchats',recentChatSchema);
export default model;