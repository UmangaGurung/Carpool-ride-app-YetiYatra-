const mongoose = require('mongoose');
const Notification = require('../Model/notificationModel'); 
const RideRequest = require('../Model/rideRequestModel');
const User = require('../Model/userModel');

const pollingInterval = 30000; 

async function pollForNotifications() {
    try {
        const rideRequests = await RideRequest.find({ status: 'pending', processed: false });

        for (const request of rideRequests) {
            const user = await User.findById(request.requester);
            const rider = await User.findOne({ username: request.rider });

            if (rider) {
                const notification = new Notification({
                    rider: rider._id,
                    message: `${user.username} has requested a ride for your scheduled trip.`,
                    image: user.image,
                    createdAt: new Date(),
                    requestId: request.id,
                    riderName: rider.username,
                    requesterName: user.username,
                    scheduleId: request.schedule
                });
       
                await notification.save();
                request.processed = true;
                await request.save();
            }
        }
    } catch (error) {
        console.error('Error in polling for notifications:', error);
    }
}

function startPolling() {
    setInterval(pollForNotifications, pollingInterval);
}

module.exports = startPolling;
