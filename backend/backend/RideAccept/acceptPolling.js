const mongoose = require('mongoose');
const RideRequest = require('../Model/rideRequestModel');
const User = require('../Model/userModel');
const UserNotification = require('../Model/acceptModel'); 

const pollingInterval = 20000; 

async function pollForNotifications() {
    try {
        const rideRequests = await RideRequest.find({ status: 'accepted', processed: false });

        for (const request of rideRequests) {
            const requester = await User.findById(request.requester);
            const rider = await User.findOne({username: request.rider});

            if (requester) {
                const requesterNotification = new UserNotification({
                    user: requester._id,
                    message: `Your ride request has been confirmed for the scheduled trip.`,
                    //
                    image: rider.image, 
                    //
                    createdAt: new Date(),
                    requestId: request._id ,
                    riderName: request.rider,
                    riderPhone: request.riderPhone,
                    scheduleId: request.schedule,
                    requester: request.requesterName
                });
                await requesterNotification.save();

                //all data that have been successfully polled are set to true
                request.processed = true;
                
                await request.save();
            } else {
                console.error(`Requester not found for request ID: ${request._id}`);
            }
        }
    } catch (error) {
        console.error('Error in polling for notifications:', error);
    }
}

function ridePolling() {
    setInterval(pollForNotifications, pollingInterval);
}

module.exports = ridePolling;

// image: requester.image, 