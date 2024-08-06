const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const routes = require('./Route/index');
const startPolling = require('./RequestPolling/pollingScript');
const ridePolling= require('./RideAccept/acceptPolling');
const session = require('express-session');

const app = express();
const port = 5000;
const path = require('path');
const url = "mongodb://localhost:27017/register";

mongoose.connect(url);

app.use(session({
    secret: 'secret',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }
}));
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));


const conDB = mongoose.connection;
conDB.on('error', console.error.bind(console, 'MongoDB connection error:'));
conDB.once('open', function () {
    console.log('Connected to MongoDB');
    startPolling();
    ridePolling();

    app.listen(port, '192.168.23.73', function () {
        console.log(`Server is running on http://192.168.23.73:${port}/`);
    });
});

app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.json());
app.use('/', routes);

