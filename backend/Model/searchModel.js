const mongoose = require('mongoose');
const { Schema } = mongoose;

const SearchSchema = new Schema({
    username: {
        type: String,
        required: true,
    },
    phone: {
        type: String,
        required: true,
    },
    searchid: {
        type: Number,
        auto: true,  
    },
    leaving: {
        type: String,
        required: true,
    },
    destination: {
        type: String,
        required: true,
    },
    date: {
        type: String,
        required: true,
    },
    noOfpassengers: {
        type: Number,
        required: true,
        min: 1,
    }
});

module.exports = mongoose.model('Search', SearchSchema);
