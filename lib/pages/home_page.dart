import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/componets/dialog_box.dart';
import 'package:todo/componets/task_tile.dart';
import 'package:todo/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // referencing the hive box
  final _myBox = Hive.box('mybox');

  // interciating the database
  // db --> database
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this the first time ever openning the app
    // then create the defual data
    if (_myBox.get('TODOLIST') == null) {
      db.creatInitialData();
    } else {
      // then its not the first time to open the app
      // then get and load the available data
      db.loadData();
    }
    super.initState();
  }

//text controller
  final _controller = TextEditingController();

// checkBoxChecked
  void checkBoxChecked(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

// create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: cancelTask,
        );
        
      },
    );
     db.updateDataBase();
  }

// save the new task
// this will add the new task to the todo list and close the dialog

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller
          .clear(); // the dailog will be cleared too after saving the task
    });
    Navigator.of(context).pop();
     db.updateDataBase();
  }

// cancel the new task
// this will close the dialog and clear it
  void cancelTask() {
    setState(() {
      Navigator.of(context).pop();

      _controller.clear();
       db.updateDataBase();
    });
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
     db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      //app bar
      appBar: AppBar(
        backgroundColor: const Color(0xff0a2342),
        elevation: 2.8,
        shadowColor: const Color(0xff181f39),

        //                     APP TITLE
        title: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'ToDo',
            style: TextStyle(
                fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),

      //                     BODY START HERE
      body: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 6.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            gradient: LinearGradient(colors: [
              const Color(0xff0a2342),
              Colors.grey.shade300,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),

          //                     TO DO TILES
          child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: ((context, index) {
                return TaskTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChecked(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              })),
        ),
      ),

      //                     FLOATING BUTTON FOR ADDING TASKS
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton(
          onPressed: createNewTask,
          backgroundColor: const Color(0xff0a2342),
          child: const Icon(
            Icons.add,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),

      // list of taks

      //floating button for adding tasks
    );
  }
}
