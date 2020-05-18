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

app.get('/goals', function(req, res) {
  var goal = db.collection('goals').doc(req.header("uid")).get().then(querySnapshot => {
    console.log(querySnapshot.data().goal)
    res.send(JSON.stringify({userGoal: querySnapshot.data().goal}))
  })
  //console.log(goal)
  //res.end(JSON.stringify({userGoal: 'test'}))

})

app.listen(3000)