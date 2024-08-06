const mongoose = require('mongoose');

// Define the connection URL
const url = 'mongodb://localhost:27017/register'; // Replace with your MongoDB connection URL

// Connect to MongoDB
mongoose.connect(url)
    .then(() => {
        console.log('Connected to MongoDB');
        printRecords(); // Call the function after successful connection
    })
    .catch(err => {
        console.error('Failed to connect to MongoDB', err);
    });

// Define the schema for the 'schedules' collection
const scheduleSchema = new mongoose.Schema({
    username: String,
    phone: String,
    leaving: String,
    destination: String,
    date: String,
    time: String,
    emptyseats: Number
});

// Create a model for the 'schedules' collection
const Schedule = mongoose.model('Schedule', scheduleSchema);

async function printRecords() {
    try {
        // Fetch all records from the 'schedules' collection
        const records = await Schedule.find({});
        console.log('Records:', records);
    } catch (error) {
        console.error('Error fetching records:', error);
    } finally {
        // Close the connection
        mongoose.connection.close();
    }
}
