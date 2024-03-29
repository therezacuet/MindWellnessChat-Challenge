import { Schema, model as _model } from 'mongoose';

const participantsSchema = new Schema({
    user1_id:{
        type:String,
        required:true,
        immutable:true,
    },
    user2_id:{
        type:String,
        required:true,
        immutable:true,
    }
});

const imageInfoSchema = new Schema({
    width:{
        type:String,
        required:true,
    },
    height:{
        type:String,
        required:true,
    }
});

const privateMessageSchema = new Schema({
    participants:{
        type:participantsSchema,
        required:true,
    },
    receiver_id:{
        type:String,
        required:true,
        immutable:true,
    },
    sender_id:{
        type:String,
        required:true,
        immutable:true,
    },
    sender_name:{
        type:String,
        required:true,
    },
    sender_placeholder_image:{
        type:String,
        default:null
    },
    msg_content:{
        type:String,
        required:true,
        immutable:true,
    },
    msg_content_type:{
        type:String,
        required:true,
        immutable:true,
    },
    created_at:{
        type:Number,
        default:Date.now()
    },
    seen_at:{
        type:Number,
        default:null
    },
    delivered_at:{
        type:Number,
        default:null 
    },
    msg_status:{
        type:Number,
        default:0
    },
    sender_local_updated:{
        type:Boolean,
        default:true
    },
    receiver_local_updated:{
        type:Boolean,
        default:false
    },
    network_file_url:{
        type:String,
        default:null
    },
    blur_hash_image:{
        type:String,
        default:null
    },
    image_info:{
        type:imageInfoSchema,
        default:null
    },
    should_update_recent_chat:{
        type:Boolean,
        default:false
    }
});

const model = _model('messages',privateMessageSchema);
export default model;