const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendEmergencyAlert = functions.firestore
  .document('users/{userId}/alerts/{alertId}')
  .onWrite((change, context) => {
    const alert = change.after.data();
      const userId = context.params.userId;
      return admin.firestore().collection('users').doc(userId).get()
        .then(doc => {
          const tokens = doc.data()?.fcmTokens || [];
          const payload = {
            notification: {
              title: 'Ongoing Panic Alert',
              body: `${alert.alerted_contact_name} has an ongoing panic alert! Click here to view
              their live location.`,
            },
          };
          return admin.messaging().sendToDevice(tokens, payload);
        });
    return null;
  });
