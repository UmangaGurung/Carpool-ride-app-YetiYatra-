const express = require('express');
const router = express.Router();
const userController = require('../Controller/userController');
const dbpolling= require('../RequestPolling/dbpolling');
const rideaccept= require('../RideAccept/rideAccept');
const rideresponse= require('../RideAccept/acceptResponse')
const updatepayment= require('../RideAccept/notificationUpdate');
const rideTaken= require('../History/takenHistory');
const rideGiven= require('../History/givenHistory');

const isAuthenticated = require('../middlewares/auth');
const multer = require('multer');    
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

//login/register, editing, ride scheduling and searching
router.post('/register', userController.upload, userController.registerUser);
router.post('/login', userController.loginUser);
router.post('/logout', userController.destryToken);
router.post('/edit', userController.changeUser);
router.post('/editpassword', userController.editPassword);
router.post('/schedule', userController.scheduleRide);
router.post('/search', userController.searchRide);
router.post('/rideRequest', userController.rideRequest);

//notifications and history
router.get('/notifications/:username', dbpolling.getNotifications);
router.post('/acceptride', rideaccept.acceptRide);
router.get('/usernotifications/:username', rideresponse.getUserNotifications);
router.post('/updatePayment', updatepayment.paymentUpdate);
router.get('/rideTaken/:username', rideTaken.takenHistory);
router.get('/rideGiven/:username', rideGiven.givenHistory);

// Admin Routes
router.get('/admin', isAuthenticated, userController.admin);
router.get('/adminlogin', userController.adminlogin);
router.post('/adminlogin', userController.adminloginpost);    
router.get('/admin/adduser', isAuthenticated, userController.adduser);
router.post('/admin/adduser', isAuthenticated, upload.single('image'), userController.adduserpost);
router.get('/admin/logout', isAuthenticated, userController.adminlogout);
router.post('/admin/deleteuser', isAuthenticated, userController.admindeleteuser);
router.post('/admin/updatephone', userController.updatePhone);
router.post('/admin/updaterole', userController.updateRole);
router.get('/schedule',isAuthenticated, userController.schedules);
router.post('/scheduledelete',isAuthenticated, userController.scheduledelete);


module.exports = router;