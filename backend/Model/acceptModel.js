const mongoose = require('mongoose');
const { Schema } = mongoose;

const AcceptSchema = new Schema({
    user: { 
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    message: {
        type: String,
        required: true
    },
    image: {
        data: Buffer,
        contentType: String
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    requestId: {
        type: Schema.Types.ObjectId,
        ref: 'RideRequest',
        required: true
    },
    riderName: { 
        type: String,
        required: true
    },
    riderPhone:{
        type: String,
        required: true
    },
    scheduleId: {  
        type: Schema.Types.ObjectId,
        ref: 'Schedule',
        required: true
    }, 
    requester: { 
        type: String,
        required: true
    },
    payed: {
        type: Boolean,
        default: false 
    },
});

module.exports = mongoose.model('UserNotification', AcceptSchema);
