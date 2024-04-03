importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');


const firebaseConfig = {
    apiKey: 'AIzaSyAaA1e_mqgw-pFUNhGfri3YmU48GABXF7w',
    appId: '1:699436605619:web:1cfa72688dbcfe186610c6',
    messagingSenderId: '699436605619',
    projectId: 'mltmenu',
    authDomain: 'mltmenu.firebaseapp.com',
    storageBucket: 'mltmenu.appspot.com',
    measurementId: 'G-FQZTDC0BDB',
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();


messaging.onBackgroundMessage(function (payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});