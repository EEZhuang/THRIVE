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


//linking goal to user
app.post('/link_user_goal', function(req, res) {
  db.collection("users")
    .doc(req.body.uid)
    .collection("user_goals")
    .doc(req.body.goalID)
        .set({

        })
})

app.post('/post_goal', function(req, res) {
  db.collection("goals")
    .doc(req.body.goalID)
        .set({
            goal_name: req.body.goal,
            goal_dates: req.body.goalDates,
            goal_units: req.body.goalUnits,
            goal_repeat: req.body.goalRepeat
        })
})

app.get('/get_goal', function(req, res) {
  var goal = db.collection('goals').doc(req.header("goalID")).get().then(querySnapshot => {
    //console.log(querySnapshot.data().goal_name)
    res.send(JSON.stringify({goal_name: querySnapshot.data().goal_name,
                             goal_dates: querySnapshot.data().goal_dates,
                             goal_units: querySnapshot.data().goal_units,
                             goal_repeat: querySnapshot.data().goal_repeat}))
  })
  //console.log(goal)
  //res.end(JSON.stringify({userGoal: 'test'}))

})

app.get('/get_all_goal_ids', function(req, res) {
  var ids = [];
  var goal = db.collection('users').doc(req.header("uid")).collection('user_goals').get().then(querySnapshot => {
       querySnapshot.forEach((doc) => {
            ids.push(doc.id);
            //console.log(doc.id);
       })
       console.log(ids);
       res.send(JSON.stringify({goal_ids: ids}));

      //console.log(querySnapshot.data().goal_name)
    })
})


app.listen(3000)