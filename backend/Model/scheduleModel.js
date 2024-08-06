const mongoose = require('mongoose');
const { Schema } = mongoose;

const ScheduleSchema = new Schema({
    username: {
        type: String,
        required: true,
    },
    phone: {
        type: String,
        required: true
    },
    scheduleid: {
        type: Schema.Types.ObjectId,
        auto: true
    },
    leaving: {
        type: String,
        required: true
    },
    destination: {
        type: String,
        required: true
    },
    date: {
        type: String,
        required: true
    },
    time: {
        type: String,  
        required: true
    },
    emptyseats: {
        type: Number,
        required: true,
        min: 1
    },
    pending: {
        type: Boolean,
        default: false 
    },
    image:{
        data: Buffer,
        contentType: String
    }
});

module.exports = mongoose.model('Schedule', ScheduleSchema);
