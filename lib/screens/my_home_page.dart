import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(223, 52, 165, 218),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        height: 60,
        child: Image.asset('assets/stand.jpg'),
      ),
      Text('Standin on Bidness',
      style: TextStyle(
        fontFamily: 'Caveat',
        fontSize: 32,
      ),
      ),
    ],
        ),
        ),
        body: Container( 
          color: Color.fromARGB(255, 4, 22, 82), 
          child: Column( 
            children: <Widget>[ 
              Expanded(
                child: Container( 
                  height: 300, 
                  color: Color.fromARGB(255, 248, 249, 250), 
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TableCalendar(
                      calendarFormat: CalendarFormat.month,
                      headerVisible: false,
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(2023),
                      lastDay: DateTime(2025),
                                    
                    ),
                  ),
                ),
              ), 
          ], 
          ), 
        ),
    );
  }
}


