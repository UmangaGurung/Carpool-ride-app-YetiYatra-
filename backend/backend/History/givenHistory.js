const Schedule = require('../Model/scheduleModel');

exports.givenHistory = async function(req, res) {
    try {
        const { username } = req.params;

        if (!username) {
            return res.status(400).json({ message: 'Username is required' });
        }

        const schedules = await Schedule.find({ username: username });

        // if (schedules.length === 0) {
        //     return res.status(404).json({ message: 'No schedules found for this user' });
        // }

        const scheduleData = schedules.map(schedule => ({
            username: schedule.username,
            phone: schedule.phone,
            scheduleId: schedule.scheduleid,
            leaving: schedule.leaving,
            destination: schedule.destination,
            date: schedule.date,
            time: schedule.time,
            emptySeats: schedule.emptyseats,
            pending: schedule.pending
        }));

        console.log(scheduleData);

        res.status(200).json({ scheduleData });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'An error occurred while fetching schedules' });
    }
};