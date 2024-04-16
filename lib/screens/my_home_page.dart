import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final List<String> tasks = <String>[];

  final List<bool> checkboxes = List.generate(8, (index) => false);

  bool isChecked = false;

  /*
  The TextEditingController class allows us to 
  grab the input from the TextField() widget
  This will be used later on to store the value
  in the database.
  */

  TextEditingController nameController = TextEditingController();

  void addItemToList() async {
    final String taskName = nameController.text;

    //Add to the Firestore collection
    await db.collection('tasks').add({
      'name': taskName,
      'completed': null,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      tasks.insert(0, taskName);
      checkboxes.insert(0, false);
    });
  }

Future<void> fetchTaskFromFirestore() async {

  //get a reference to the 'task' collection in Firestore

  CollectionReference taskCollection = db.collection('tasks');

  //fetch the documents (tasks) from the collection
  QuerySnapshot querySnapshot = await taskCollection.get();

  //create an empty list to store the fetch tasks names
  List<String> fetchedTasks = [];

  //look through each doc (task) in the querySnapshot object

  for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs){
    //Getting the task name from the documents's data
    String taskName = docSnapshot.get('name');

    //Getting the completion status ofthe task
    bool completed = docSnapshot.get('completed');

    //Add the task name to the list of the fetched data.
    fetchedTasks.add(taskName);
  } 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(220, 21, 75, 221),
        /*
            Rows() and Columns() both have the mainAxisAlignment 
            property we can utilize to space out their child 
            widgets to our desired format.
           */
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              /*
            SizedBox allows us to control the vertical 
            and horizontal dimensions by manipulating the 
            height or width property, or both.
            */
              height: 70,
              child: Image.asset('assets/stand.jpg'),
            ),
            Text(
              'Standin on bizness',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 50, 116, 216),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 300,
                color: Color.fromARGB(255, 227, 232, 245),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      /*
          The TableCalendar() widget below is installed via 
          "flutter pub get table_calendar" or by adding the package 
          to the pubspec.yaml file.  We then import it and implement using
          configuration properties.  You can set a range and a focus day. 
          The particulars of implementation for any package can be gleaned 
          from pub.dev: https://pub.dev/packages/table_calendar.
          */
                      TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2023),
                    lastDay: DateTime(2025),
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(4),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: checkboxes[index]
                            ? Color.fromARGB(255, 112, 233, 116).withOpacity(0.7)
                            : Color.fromARGB(255, 248, 70, 138).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            !checkboxes[index]
                            ?Icons.manage_history 
                            :Icons.playlist_add_check_circle,
                            size: 32,
                          ),
                          SizedBox(width: 18),
                          Text(
                            '${tasks[index]}',
                            style: checkboxes[index]
                            ? TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.5)
                            ) :TextStyle(fontSize: 20),
                          ),
                          Checkbox(
                            value: checkboxes[index],
                            onChanged: (newValue) {
                              setState(() {
                                checkboxes[index] = newValue!;
                              });
                            },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: null,
                            )
                        ],
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 25, right: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(fontSize: 18),
                        maxLength: 20,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Wat you want??',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 8, 14, 19),
                          ),
                          hintText: 'State your goal',
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 63, 153, 226), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  addItemToList();
                },
                child: Text('Add your goal'),
              ),
            )
          ],
        ),
      ),
    );
  }
}