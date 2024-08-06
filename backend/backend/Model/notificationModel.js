const mongoose = require('mongoose');
const { Schema } = mongoose;

const NotificationSchema = new Schema({
    rider: {
        type: String,
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
    requesterName: {
        type: String,
        required: true
    },
    scheduleId: {  
        type: Schema.Types.ObjectId,
        ref: 'Schedule',
        required: true
    }, 
    accepted: {
        type: Boolean,
        default: false 
    },
});

module.exports = mongoose.model('Notification', NotificationSchema);
