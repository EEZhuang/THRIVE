const admin = require('firebase-admin')
const serviceAccount = require('./ServiceAccountKey.json')
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
})
const db = admin.firestore();


var bodyParser = require('body-parser')
var firebase = require("firebase/app")
var express = require('express')
var auth = require("firebase/auth");
var app = express()
app.use(bodyParser.json())



app.post('/goals', function(req, res) {
  db.collection("goals")
    .doc(req.body.uid)
        .set({
            goal: (req.body.goal)
        })
})

app.listen(3000)