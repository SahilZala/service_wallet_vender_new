import 'package:flutter/material.dart';

import '../last_page.dart';

class TrainCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrainingCenter(),
    );
  }
}
class TrainingCenter extends StatefulWidget {
  @override
  _TrainingCenterState createState() => _TrainingCenterState();
}

class _TrainingCenterState extends State<TrainingCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(0,0,102,1),
        elevation:0.0,
        // iconTheme: IconThemeData(color: Color.fromRGBO(0,0,102, 1)),
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back_outlined),
        //     tooltip: 'Menu Icon',
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_rounded),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Setting Icon',
            onPressed: ()=>Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=>Last_Page(),
              ),
            ),
          ), //IconButton
        ], //<Widget>[]

      ),
    );
  }
}
