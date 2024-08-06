const admin = require('firebase-admin');
const serviceAccount = require('./firebase.config.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const message = {
  notification: {
    title: 'Hello World!',
    body: 'This is a test notification from Firebase.'
  },
  token: 'dr7GWEc7SeCMx2C_ZyXq8f:APA91bFB7ACayZN9Jkn1E3VfxWoHLbuxmmlrdErEYRh2HBreODYJ68UsukCpD2C5S-qWutPTih83LuClsf0Fg8xYG6eSTeQMOhzkRTtlyimbiSm6zCUwzFhzLxqGyMFBbotf5GoFLRb9' 
};

admin.messaging().send(message)
  .then((response) => {
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });
