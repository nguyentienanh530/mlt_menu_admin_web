importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');


const firebaseConfig = {
    apiKey: 'AIzaSyCAxuoVLGByF-CiUL7mlXHvjMoDdCWlqRo',
    appId: '1:887142047579:web:88c153ed7555b48948c47e',
    messagingSenderId: '887142047579',
    projectId: 'minhlong-menu',
    authDomain: 'minhlong-menu.firebaseapp.com',
    storageBucket: 'minhlong-menu.appspot.com',
    measurementId: 'G-YPPLV69NT4',
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