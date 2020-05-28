import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';

class EditGoal extends StatefulWidget {
  final Goal goal;

  EditGoal({this.goal});

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";

  String goal_name = '';

  String goalUnits = '';

  String goalDate = '';

  String goalRepeat = '';

  String _goalDeadline = '';

  final _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    goal_name = widget.goal.goal;
    goalUnits = widget.goal.goalUnits;
    goalDate = widget.goal.goalDate;
    goalRepeat = widget.goal.goalRepeat;
    _goalDeadline = goalDate;
    var dateText = TextEditingController(text: goalDate);

    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: (){
        showDialog(
            context: context,
            builder: (context) {
              String _selectedRepeat = goalRepeat;
              String _goalDeadline = goalDate;
              return StatefulBuilder(
                  builder: (context, setState) {
                    return new AlertDialog(
                        title: new Text('Edit Goal'),
                        content: new Container(
                          width: 400,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Form(
                              key: _formkey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  TextFormField(
                                    initialValue: goal_name,
                                    decoration: new InputDecoration(
                                        hintText: "Goal Name"),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    initialValue: goalUnits,
                                    decoration: new InputDecoration(
                                        hintText: "How Many Units(Optional)"),
                                  ),
                                  SizedBox(height: 20.0),
                                  InkWell(
                                      onTap: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2018),
                                            lastDate: DateTime.now().add(
                                                Duration(days: 365))
                                        ).then((date) {
                                          setState(() {
                                            _goalDeadline =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(date);
                                            dateText.text = _goalDeadline;
                                            //_goalDeadline = goalDate;
                                          });
                                        });
                                      },

                                      child: IgnorePointer(
                                          child: new TextFormField(
                                              decoration: new InputDecoration(
                                                  hintText: "Goal Deadline"
                                              ),
                                              controller: dateText,
                                              validator: (value) {
                                                if (value.isEmpty){
                                                  return "Please set a deadline for your goal";

                                                }
                                                goalDate = value;
                                                _goalDeadline = value;
                                                return null;
                                              }
                                          )
                                      )
                                  ),
                                  SizedBox(height: 20.0),
                                  DropdownButton<String>(
                                    hint: Text("Repeat"),
                                    value: _selectedRepeat,
                                    items: <String>[
                                      "Don't Repeat",
                                      "Repeat Every Day",
                                      "Repeat Every Week",
                                      "Repeat Every Month",
                                      "Repeat Every Year"
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRepeat = value;
                                        print(_selectedRepeat);
                                        goalRepeat = value;
                                      });
                                    },
                                  ),


                                ],
                              )

                          ),
                        )
                    );
                  }
              );
            }

        );
      },


    );
  }
}
