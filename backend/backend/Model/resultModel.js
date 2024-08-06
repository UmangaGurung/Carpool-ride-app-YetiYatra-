const mongoose = require('mongoose');
const { Schema } = mongoose;

const ResultsSchema = new Schema({
    searchId: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'Search'  
    },
    publishedRides: [{
        type: Schema.Types.ObjectId,
        ref: 'Publish'  
    }],
    searchDate: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Results', ResultsSchema);
