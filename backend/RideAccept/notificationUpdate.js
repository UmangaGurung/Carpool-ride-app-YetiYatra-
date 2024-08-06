const UserNotification = require('../Model/acceptModel');
const Schedule = require('../Model/scheduleModel');

exports.paymentUpdate = async function (req, res) {
  console.log(req.body);
  const { scheduleId, notificationId, status } = req.body;

  if (!notificationId || status === undefined) {
    return res.status(400).json({ message: 'Notification ID and status are required' });
  }

  try {
    const updatedNotification = await UserNotification.findByIdAndUpdate(
      notificationId,
      { payed: status },
      { new: true }
    );

    if (!updatedNotification) {
      return res.status(404).json({ message: 'Notification not found' });
    }

    const updateSchedule = await Schedule.findOneAndUpdate(
      { scheduleid: scheduleId },
      { $set: { pending: true } },
      { new: true, runValidators: true }
    );

    if (!updateSchedule) {
      return res.status(404).json({ message: 'Schedule not found' });
    }

    console.log(updatedNotification);
    res.status(200).json({
      message: 'Payment status updated and schedule pending status changed successfully',
      notification: updatedNotification,
      schedule: updateSchedule
    });
  } catch (error) {
    console.error('Error updating payment status:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
