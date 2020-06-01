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

//Linking Users Friends
app.post('/link_friends', function(req, res) {
  db.collection("connections")
    .doc(req.body.requestingUID + ' ' + req.body.requestedUID )
        .set({
            friendRequesting: req.body.requestingUID,
            friendRequested: req.body.requestedUID,
            accepted: false
        })
})

//linking goal to user
app.post('/link_user_goal', function(req, res) {
  //console.log(req.body('uid'));
  var goal = db.collection('usernames').doc(req.body.username).collection("user_goals").doc(req.body.goalID).set({})

})

app.post('/delete_goal', function(req, res) {
  //console.log(req.body('uid'));

    var goal = db.collection('usernames').doc(req.body.username).collection("user_goals").doc(req.body.goalID).delete()
    var goal2 = db.collection('goals').doc(req.body.goalID).delete()
    res.send(JSON.stringify('done'));


})


app.post('/delete_connection', function(req, res) {

  db.collection('connections').where("friendRequested", "==", req.body.myuid).where("friendRequesting", "==", req.body.frienduid).get()
    .then(function(querySnapshot) {
          // Once we get the results, begin a batch
          var batch = db.batch();

          querySnapshot.forEach(function(doc) {
              // For each doc, add a delete operation to the batch
              batch.delete(doc.ref);
          });

          // Commit the batch
          return batch.commit();
    }).then(function() {
        // Delete completed!
        // ...
    });

  //console.log(req.body.frienduid);

})

app.post('/post_goal', function(req, res) {
  db.collection("goals")
    .doc(req.body.goalID)
        .set({
            goal_name: req.body.goal,
            goal_dates: req.body.goalDates,
            goal_units: req.body.goalUnits,
            goal_repeat: req.body.goalRepeat,
            goal_progress: req.body.goalProgress,
            timestamp: req.body.timestamp
        })
   res.send(JSON.stringify('done'));
})

app.post('/set_user_info', function(req, res) {
  db.collection("users")
    .doc(req.body.uid)
        .set({
            username: req.body.username,
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            birthDate: req.body.birthDate
        })
  res.send()
})

app.post('/set_user_avatar', function(req, res) {
    console.log("ABOUT TO SET THE AVATAWWWW");
  db.collection("usernames")
    .doc(req.body.username)
        .set({
            colorIndex: req.body.colorIndex,
            iconIndex: req.body.iconIndex,
        })
  res.send()
})

app.get('/get_user_avatar', function(req, res) {
  var avatar = db.collection('usernames').doc(req.header("username")).get().then(querySnapshot => {
    res.send(JSON.stringify({colorIndex: querySnapshot.data().colorIndex,
                             iconIndex: querySnapshot.data().iconIndex}))
  })
})


app.post('/set_public_uid', function(req, res) {
  db.collection("usernames")
    .doc(req.body.username)
        .set({
        })
})

app.post('/set_friend', function(req, res) {
  db.collection("usernames")
    .doc(req.body.myusername)
        .collection("friends")
            .doc(req.body.otherusername).set({})


})


app.get('/get_goal', function(req, res) {
  var goal = db.collection('goals').doc(req.header("goalID")).get().then(querySnapshot => {
    //console.log(querySnapshot.data().goal_name)
    res.send(JSON.stringify({goal_name: querySnapshot.data().goal_name,
                             goal_dates: querySnapshot.data().goal_dates,
                             goal_units: querySnapshot.data().goal_units,
                             goal_repeat: querySnapshot.data().goal_repeat,
                             goal_progress: querySnapshot.data().goal_progress,
                             timestamp: querySnapshot.data().timestamp}))
  })
  //console.log(goal)
  //res.end(JSON.stringify({userGoal: 'test'}))

})


app.get('/get_all_goal_ids', function(req, res) {
  var ids = [];
  var goal = db.collection('usernames').doc(req.header('username')).collection('user_goals').get().then(querySnapshot => {
         querySnapshot.forEach((doc) => {
              ids.push(doc.id);
              //console.log(doc.id);
         })
         console.log(ids);
         res.send(JSON.stringify({goal_ids: ids}));

        //console.log(querySnapshot.data().goal_name)
  })


})

app.get('/get_all_friends', function(req, res) {
  var friends = [];
  var goal = db.collection('usernames').doc(req.header('username')).collection('friends').get().then(querySnapshot => {
         querySnapshot.forEach((doc) => {
              friends.push(doc.id);
              //console.log(doc.id);
         })
         console.log(friends);
         res.send(JSON.stringify({friend: friends}));

        //console.log(querySnapshot.data().goal_name)
  })


})

app.get('/get_all_usernames', function(req, res) {
  var usernames = [];
  //console.log(db.collection('usernames').get());
  var goal = db.collection('usernames').get().then(querySnapshot => {
       querySnapshot.forEach((doc) => {
            usernames.push(doc.id);
            //console.log(doc.id);
       })
       console.log(usernames);
       res.send(JSON.stringify({users: usernames}));

      //console.log(querySnapshot.data().goal_name)
    })
})

app.get('/get_username', function(req, res) {

  var usernames = "";
  //console.log(db.collection('usernames').get());
  var goal = db.collection('users').doc(req.header("uid")).get().then(querySnapshot => {
       console.log(querySnapshot.data())
       usernames = querySnapshot.data().username
       console.log(usernames);
       res.send(JSON.stringify({user: usernames}));

      //console.log(querySnapshot.data().goal_name)
    })
})

app.get('/get_requests', function(req, res) {

  var usernames = [];
  //console.log(db.collection('usernames').get());
  console.log(req.header("uid"));
  var goal = db.collection('connections').where("friendRequested", "==", req.header('uid')).where("accepted", "==", false).get().then(querySnapshot => {
       querySnapshot.forEach((doc) => {
           usernames.push(doc.id.substr(0,doc.id.indexOf(' ')));
           //console.log(doc.id);
       })

       console.log("yeet" + usernames)
       res.send(JSON.stringify({friend: usernames}));

      //console.log(querySnapshot.data().goal_name)
    })
})


app.listen(3000)