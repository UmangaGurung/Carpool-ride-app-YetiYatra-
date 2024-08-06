const Notification = require('../Model/notificationModel');
const User = require('../Model/userModel');
const RequestModel = require('../Model/rideRequestModel')

exports.acceptRide = async function (req, res) {
    console.log(req.body);
    try {
        const { username, phone, requestId, notificationId, scheduleId, accepted} = req.body
        const result = await RequestModel.findByIdAndUpdate(
            requestId,
            { status: 'accepted', processed: false },
            { new: true }
        );

        const notifications = await Notification.find({ scheduleId });

        await Notification.updateMany(
            { scheduleId },
            { $set: { accepted: true } }
        );

        console.log(result);

        if (!result) {
            return res.status(404).send('Ride request not found');
        }

        res.status(200).send('Ride request accepted');
    } catch (error) {
        console.error('Error accepting ride:', error);
        res.status(500).json({ message: 'Internal server error' });
    }

};
