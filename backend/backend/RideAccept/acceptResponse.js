const Notification = require('../Model/notificationModel');
const UserNotification = require('../Model/acceptModel');
const User = require('../Model/userModel');
const RideRequest= require('../Model/rideRequestModel');

exports.getUserNotifications = async function(req, res) {
    try {
        const { username } = req.params;
        const user = await User.findOne({ username });

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        
        const userNotifications = await UserNotification.find({ user: user._id }).sort({ createdAt: -1 });

        const userNotificationData = userNotifications.map(notification => {
            const imageBase64 = notification.image?.data ? notification.image.data.toString('base64') : null;
            return {
                _id: notification._id,
                user: notification.user,
                message: notification.message,
                image: imageBase64,
                createdAt: notification.createdAt,
                requestId: notification.requestId,
                riderName: notification.riderName,
                riderPhone: notification.riderPhone,
                scheduleId: notification.scheduleId,
                requester: notification.requester,
                payed: notification.payed
            };
        });

        console.log(userNotificationData);
        
        res.status(200).json({
            message: 'Notifications fetched successfully',
            notifications: userNotificationData
        });
    } catch (error) {
        console.error('Error fetching notifications:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
