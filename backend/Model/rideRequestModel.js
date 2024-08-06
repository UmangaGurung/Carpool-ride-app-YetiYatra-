const mongoose = require('mongoose');
const { Schema } = mongoose;

const RideRequestSchema = new Schema({
    requester: {
        type: Schema.Types.ObjectId, 
        ref: 'User',
        required: true
    },
    requesterName: { 
        type: String,
        required: true
    },
    requesterPhone: { 
        type: String,
        required: true
    },
    leaving: {
        type: String,
        required: true
    },
    destination: {
        type: String,
        required: true
    },
    rider:{
        type: String,
        required: true
    },
    riderPhone:{
        type: String,
        required: true
    },
    schedule: {
        type: Schema.Types.ObjectId,
        ref: 'Schedule',
        required: true
    },
    noOfpassengers:{
        type: Number,
        required: true,
    },
    status: {
        type: String,
        enum: ['pending', 'accepted', 'rejected'],
        default: 'pending'
    },
    processed: {
        type: Boolean,
        default: false
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
});

module.exports = mongoose.model('RideRequest', RideRequestSchema);
