const RideRequest = require('../Model/rideRequestModel');

exports.takenHistory = async function(req, res) {
    try {
        const { username } = req.params; 

        const rideRequests = await RideRequest.find({
            requesterName: username
        }).sort({ createdAt: -1 });

        const rideRequestData = rideRequests.map(request => ({
            _id: request._id,
            requesterName: request.requesterName,
            requesterPhone: request.requesterPhone,
            rider: request.rider,
            riderPhone: request.riderPhone,
            leaving: request.leaving,
            destination: request.destination,
            scheduleId: request.schedule,
            noOfPassengers: request.noOfpassengers,
            status: request.status,
            createdAt: request.createdAt
        }));

        console.log(rideRequestData);
        res.status(200).json({
            message: 'Ride requests fetched successfully',
            rideRequests: rideRequestData
        });
    } catch (error) {
        console.error('Error fetching ride requests:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
