const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

// Intialize the firebase-admin project/account
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const sendNotification = async (req, res) => {
  var title = req.body.title || "Need a good excuse to not cook!";
  var body = req.body.body || "Here's one";
  await admin.messaging().sendMulticast({
    tokens: [
      "cStQ_CHkRcK1MleScAdjMO:APA91bHhSCbaJJYfnwoOVGu2G8JxtyzmDxWyXWPQSYEN5usS-0NBMxDwqfIAwCp4LeZlQv0HV59XtsHck1Gncw8QK5715njAw_jMK38IVS15SG7mHrsgduvJjJkpOXeyRdosMnu7Wzyp",
    ],
    notification: {
      title: title,
      body: body,
      imageUrl:
        "https://www.kasandbox.org/programming-images/avatars/duskpin-sapling.png",
    },
  });
  res.status(200).json({
    message: "Notification sent!",
    status: true,
  });
};

module.exports = {
  sendNotification,
};
