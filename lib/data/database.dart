import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
//a list where tasks will be added
  List toDoList = [];

  //referencing the box
  final _myBox = Hive.box('mybox');

  // this method will run if app is opened for the first time
  void creatInitialData() {
    toDoList = [
      ['Welcome to second memory', false],
      ['Remember it all', false]
    ];
  }

  // roading data from the dataBase
  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  // upadate the dataBase if the user makes any changes
  void updateDataBase() {
    _myBox.put('TODOLIST', toDoList);
  }
}
