const Notification = require('../Model/notificationModel');
const scheduleModel = require('../Model/scheduleModel');
const User= require('../Model/userModel');

exports.getNotifications = async function(req, res) {
    try {
        const { username } = req.params;
        // console.log(`Fetching notifications for user: ${username}`);

        const user= await User.findOne({username});

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
 
        const notifications = await Notification.find({ rider: user._id }).sort({ createdAt: -1 });
           
        const notificationData = notifications.map(notification => {
            const imageBase64 = notification.image?.data ? notification.image.data.toString('base64') : null;
            
            return {
                _id: notification._id,
                rider: notification.rider,
                message: notification.message,
                image: imageBase64,
                createdAt: notification.createdAt,
                requestid: notification.requestId,
                riderName: notification.riderName,
                requesterName: notification.requesterName,
                scheduleId: notification.scheduleId,
                accepted: notification.accepted
            };
        });

        console.log(notificationData);
        
        res.status(200).json({
            message: 'Notifications fetched successfully',
            notifications: notificationData
        });
    } catch (error) {
        console.error('Error fetching notifications:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

