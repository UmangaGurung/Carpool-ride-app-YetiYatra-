const userModel = require('../Model/userModel');
const jwt = require('jsonwebtoken');

class userService {
    static async checkUser(username) {
        try {
            return await userModel.findOne({ username }); 
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }
}

module.exports = userService;