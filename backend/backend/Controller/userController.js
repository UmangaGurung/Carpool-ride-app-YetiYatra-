const userModel = require('../Model/userModel');
const userService = require('../Services/service');
const service = require('../Services/service');
const bcrypt = require('bcrypt');
const scheduleModel = require('../Model/scheduleModel');
const searchModel= require('../Model/searchModel');
const rideModel= require('../Model/rideRequestModel');

const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

// Register a new user
exports.registerUser = async function(req, res) {
    console.log(req.body);
    const { username, password, phone, gender } = req.body;

    try {
        let image = null;
        if (req.file) {
            image = {
                data: req.file.buffer,
                contentType: req.file.mimetype
            };
        }

        const newUser = new userModel({ username, password, phone, gender, image });
        await newUser.save();

        res.status(201).json({ message: 'User registered successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Middleware for file upload
exports.upload = upload.single('image');


//User Login
exports.loginUser = async function(req, res) {
    const { username, password } = req.body;

    try {
        const user = await service.checkUser(username);

        if (!user) {
            throw new Error('User does not exist');
        }

        const pass = password;
        const hashFromDb = user.password;

        console.log('Hash from DB:', hashFromDb);
        console.log('Hash length:', hashFromDb.length);

        const isMatch = await bcrypt.compare(pass, hashFromDb);
        console.log('Password match result:', isMatch);
        

        if (!isMatch) {
            throw new Error('Wrong Password');
        }

        const imageBase64 = user.image.data.toString('base64');

        let tokenData = {
            _id: user._id,
            username: user.username,
            phone: user.phone,
            image: imageBase64
        };

        const token = await service.generateToken(tokenData, 'secretKey', '30d');

        res.status(200).json({ status: true, token: token });
    } catch (err) {
        console.error('Login Error:', err.message);
        res.status(500).json({ error: err.message });
    }
};


//User Edit Profile
exports.changeUser = async function(req, res) {
    console.log(req.body);
    const { olduser, username, phone } = req.body;
    
    try {
        const updateUser = await userModel.findOneAndUpdate(
            { username: olduser },
            { username, phone },
            { new: true }
        );

        if (!updateUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        console.log('User updated:', updateUser);
        return res.status(200).json(updateUser); 
    } catch (err) {
        console.error('Error updating user:', err.message);
        return res.status(500).json({ error: err.message });
    }
};


//User Edit Password
exports.editPassword = async function(req, res) {
    console.log(req.body);
    const { username, oldpassword, newpassword } = req.body;

    if (!username || !oldpassword || !newpassword) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const user = await userModel.findOne({ username });
        if (!user) {
            return res.status(404).json({ error: 'User does not exist' });
        }

        const isMatch = await bcrypt.compare(oldpassword, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Old password is incorrect' });
        }

        user.password = newpassword; 
        await user.save();

        console.log('Password updated successfully');
        return res.status(200).json({ message: 'Password updated successfully' });

    } catch (err) {
        console.error('Error updating password:', err.message);
        return res.status(500).json({ error: 'Internal server error', details: err.message });
    }
};


//Register and Schedule a Ride
exports.scheduleRide = async function(req, res) {
    try {
        console.log(req.body);
        
        const { username, phone, leaving, destination, date, time, emptyseats } = req.body;

        const user = await userModel.findOne({ username });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        
        const existingRides = await scheduleModel.find({
            username,
            pending: false,
        });

        if (existingRides.length > 0) {
            return res.status(400).json({ message: 'You cannot publish a new ride until your existing scheduled ride is confirmed.' });
        }

        const image = {
            data: user.image?.data,
            contentType: user.image?.contentType
        };
        const newSchedule = new scheduleModel({
            username,
            phone,
            leaving,
            destination,
            date,
            time,
            emptyseats,
            image
        });

        await newSchedule.save();

        res.status(200).json({ message: 'Ride scheduled successfully!' });
    } catch (error) {
        console.error('Error scheduling ride:', error);
        res.status(500).json({ message: 'Failed to schedule ride' });
    }
};


exports.searchRide = async function(req, res) {
    try {
        console.log(req.body);

        const { username, phone, leaving, destination, date, noOfpassengers } = req.body;

        // Validate required fields
        if (!username || !phone || !leaving || !destination || !date || !noOfpassengers) {
            return res.status(400).json({ message: 'All fields are required.' });
        }

        const newSearch = new searchModel({
            username,
            phone,
            leaving,
            destination,
            date,
            noOfpassengers,
        });

        console.log(newSearch);
        
        const results = await scheduleModel.find({
            leaving,
            destination,
            date,
            emptyseats: { $gte: noOfpassengers },
            pending: false
        }).select('username phone scheduleid leaving destination date time emptyseats image.data');

        const processedResults = results.map(result => {
            let base64ImageData = null;
            if (result.image && result.image.data) {
                base64ImageData = result.image.data.toString('base64');
            }

            return {
                ...result.toObject(),
                image: base64ImageData 
            };
        });
``
        console.log(processedResults);
        res.status(200).json({ message: 'Ride search scheduled successfully!', results: results });
    } catch (error) {
        console.error('Error scheduling ride search:', error);
        res.status(500).json({ message: 'Failed to schedule ride search' });
    }
};


exports.rideRequest= async function(req, res){
    console.log(req.body);

    try {
        const { username, phone, rider, riderphone, leaving, destination, scheduleid, noOfpassengers } = req.body;

        if (!username || !phone || !rider || !riderphone || !scheduleid || !noOfpassengers) {
            return res.status(400).json({ message: 'Missing required fields' });
        }

        const schedule = await scheduleModel.findOne({ scheduleid: scheduleid });
        console.log(schedule.scheduleid);
        if (!schedule) {
            return res.status(404).json({ message: 'Schedule not found' });
        }

        const user = await userModel.findOne({ username, phone });
        console.log(user.username);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        const existingRequest = await rideModel.findOne({
            requester: user._id,
            schedule: schedule.scheduleid,
            status: 'pending'
        });

        if (existingRequest) {
            return res.status(400).json({ message: 'Ride request already exists for this schedule' });
        }
        
        const newRideRequest = new rideModel({
            requester: user._id, 
            requesterName: user.username, 
            requesterPhone: user.phone, 
            rider: schedule.username,
            riderPhone: schedule.phone,
            leaving: schedule.leaving,
            destination: schedule.destination,
            schedule: schedule.scheduleid,
            noOfpassengers,
            status: 'pending'
        });
        
        await newRideRequest.save();
        
        res.status(201).json({
            message: 'Ride request created successfully',
            rideRequest: newRideRequest
        });


    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

//Destroy JW Token of User
exports.destryToken = async function(req, res) {
    const token = req.header('Authorization').replace('Bearer ', '');
    try {
        console.log(`Received token for invalidation: ${token}`);  
        res.status(200).json({ message: 'Token invalidated successfully' });
    } catch (err) {
        console.error('Error invalidating token:', err.message);
        res.status(500).json({ error: err.message });
    }
};


exports.admin = async function(req, res) {
    try {
        const sessionData = req.session.user;
        
        const users = await userModel.find({}); 
        
        res.render('admin', { session: req.session, users });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.adminlogin = async function(req, res) {
        res.render('login');
};

exports.adminloginpost = async function(req, res) {
    try {
        const { username, password } = req.body;

        // Find the user in the database
        const user = await userModel.findOne({ username });


        // Check if user exists
        if (!user) {
            return res.status(401).json({ message: 'Username not found' });
        }

        // Check if password matches
        const isPasswordMatch = await bcrypt.compare(password, user.password);
        if (!isPasswordMatch) {
            return res.status(401).json({ message: 'Incorrect password' });
        }

        // Check if user is an admin
        if (user.isAdmin!=true) {
            console.log(user);
            console.log(user.isAdmin);
            console.log(user.username);
            return res.status(403).json({ message: 'Access denied. Not an admin.' });
        }

        // Create session data
        req.session.user = {
            _id: user._id,
            username: user.username,
            isAdmin: user.isAdmin,
        };

        // Redirect to admin panel
        res.redirect('/admin');
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.adminlogout = async function(req, res) {
    try {
        req.session.destroy(err => {
            if (err) {
                return res.status(500).send('Failed to log out');
            }
            res.redirect('/adminlogin'); // Change this to your actual admin login route
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};


exports.adduser = async function(req, res) {
        res.render('adduser');
};

exports.adduserpost = async function(req, res) {
    console.log(req.body);
    const { username, password, phone, gender } = req.body;

    try {
        let image = null;
        if (req.file) {
            image = {
                data: req.file.buffer,
                contentType: req.file.mimetype
            };
        }

        // const salt = await bcrypt.genSalt(10);
        // const hashedPassword = await bcrypt.hash(password, salt);

        const newUser = new userModel({
            username,
            // password: hashedPassword,
            password,
            phone,
            gender,
            image
        });

        await newUser.save();
        res.redirect("/admin");
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.admindeleteuser = async function(req, res) {
    try {
        const username = req.body.username; // Expect username in the request body
        console.log(username);
        await userModel.findOneAndDelete({ username: username });
        res.status(200).send({ message: 'User deleted successfully' });
    } catch (error) {
        res.status(500).send({ message: 'Error deleting user', error });
    }
};
exports.updatePhone = async function(req, res) {
    try {
        const { username, phone } = req.body;
        const updatedUser = await userModel.findOneAndUpdate(
            { username },
            { phone },
            { new: true }
        );
        if (updatedUser) {
            res.status(200).send({ message: 'Phone number updated successfully', user: updatedUser });
        } else {
            res.status(404).send({ message: 'User not found' });
        }
    } catch (error) {
        res.status(500).send({ message: 'Error updating phone number', error });
    }
};

exports.updateRole = async function(req, res) {
    try {
        const { username, isAdmin } = req.body;
        const updatedUser = await userModel.findOneAndUpdate(
            { username },
            { isAdmin },
            { new: true }
        );
        if (updatedUser) {
            res.status(200).send({ message: 'Role updated successfully', user: updatedUser });
        } else {
            res.status(404).send({ message: 'User not found' });
        }
    } catch (error) {
        res.status(500).send({ message: 'Error updating role', error });
    }
};
exports.schedules = async function(req, res) {
    try {
        const sessionData = req.session.user;
        
        const schedules = await scheduleModel.find(); 
        
        res.render('schedule', { session: req.session, schedules });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
exports.scheduledelete = async (req, res) => {
  const { id } = req.body;
  console.log(id);
  try {
    await scheduleModel.findByIdAndDelete(id);
    res.status(200).json({ message: 'Schedule deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to delete schedule' });
  }
};
