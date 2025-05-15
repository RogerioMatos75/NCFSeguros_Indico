const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Initialize Firebase Cloud Messaging
const messaging = firebase.messaging();

// Request permission for notifications
messaging.requestPermission()
  .then(() => {
    console.log('Notification permission granted.');
    return messaging.getToken();
  })
  .then((token) => {
    // Send this token to your server
    console.log('FCM Token:', token);
  })
  .catch((err) => {
    console.log('Unable to get permission to notify.', err);
  });

// Handle incoming messages
messaging.onMessage((payload) => {
  console.log('Message received:', payload);
  // Handle the message
});
