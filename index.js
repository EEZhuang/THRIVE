const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');
//initialize admin SDK using serviceAcountKey
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});
const db = admin.firestore();

var express = require('express')

var app = express()

app.get('/notes', function(req, res) {
  res.json({notes: "This is your notebook. Edit this to start saving your notes!"})
  db.collection("goals")
     .doc("yPSVpkNSMOPN5k09mOGnhUIpmkb2")
      .set({
          goal: "update pls",
  });
})

app.listen(3000)