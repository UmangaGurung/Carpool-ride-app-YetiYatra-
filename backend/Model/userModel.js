const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const { Schema } = mongoose;
const UserSchema = new Schema({
    username: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    phone: {
        type: String,
        required: true,
        unique: true
    },
    gender: {
        type: String,
        required: true
    },
    image: {
        data: Buffer,
        contentType: String
    },
    isAdmin: {
        type: Boolean,
        default: false 
    } 
});

UserSchema.pre('save', async function(next) {
    try {
        var user = this;
        if (!user.isModified('password')) {
            return next();
        }
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(user.password, salt);
    
        user.password = hash;
        next();
    } catch (error) {
        next(error);
    }
});

// UserSchema.methods.comparePassword = async function(candidatePassword) {
//     try {
//         const isMatch = await bcrypt.compare(candidatePassword, this.password);
//         return isMatch;
//     } catch (error) {
//         throw error;
//     }
// };

module.exports = mongoose.model('User', UserSchema);
