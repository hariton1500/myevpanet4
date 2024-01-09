importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyASdhC_reDhl6TOt6yN2oTTwWwmZ8kfDFU',
  appId: '1:945032935281:web:ba5cae18d446c97eede8d0',
  messagingSenderId: '945032935281',
  projectId: 'evpanet-f3ea6',
  authDomain: 'evpanet-f3ea6.firebaseapp.com',
  databaseURL: 'https://evpanet-f3ea6.firebaseio.com',
  storageBucket: 'evpanet-f3ea6.appspot.com',
  measurementId: 'G-6LPX0K2HC4',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
