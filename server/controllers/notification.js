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
      "cB99XYGCRXCLUYmqQdK8Sh:APA91bFqxcSuAbfGUT4maD8kgHLCwJJY_qf96uR9CfiRTUr1a5ayiEty6vBogoTf1dPKdX1WY-T4KKohQb23LSlyWolJuC0OhucIE0O9Y_VjuaD2j4YBmyrE8XsHgTFsDORG-GVdrxot",
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
