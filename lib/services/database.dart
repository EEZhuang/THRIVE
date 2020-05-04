import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/models/user.dart';
class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference goalCollection = Firestore.instance.collection('goals');

  Future updateUserData(String goal, String name, String days) async{
    return await goalCollection.document(uid).setData({
      'goal': goal,
      'name': name,
      'days': days,
    }); //will automatically create document if sees new uid
  }

  //Goal list from snapshot
  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map( (doc) {
      return Goal(
        name: doc.data['name'] ?? '',
        days: doc.data['days'] ?? '0',
        goal: doc.data['goal'] ?? 'no goal'

      );
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      goal: snapshot.data['goal'],
      days: snapshot.data['days'],
    );
  }


  //get goals stream
  Stream<List<Goal>> get goals {
    return goalCollection.snapshots()
      .map(_goalListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return goalCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
}