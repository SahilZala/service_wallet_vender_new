import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'nav_bar.dart';x

class Last_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark().copyWith(
        //   primaryColor: Colors.pink,
          // scaffoldBackgroundColor: Color(0xFF0A0E21),

        home: Scaffold(
          backgroundColor: Colors.white,
           // drawer: NavDrawer(),
          appBar: AppBar(
            title: Text("Menu"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.pop(context);
                }
            ), //

            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(18.0),
            //     side: BorderSide(color: Colors.red)
            // ),
            backgroundColor:Color.fromRGBO(0,0,102,1),
            elevation:14.0,
            // borderRadius: BorderRadius.circular(12.0),
            // title: Text("Menu",
            //   style: TextStyle(
            //       fontFamily: 'Newsreader',
            //        fontWeight: FontWeight.bold),),

            // shadowColor: Colors.pink,
            // leading: GestureDetector(
            //   onTap: () { /* Write listener code here */ },
            //   child: Icon(
            //     CupertinoIcons.chevron_left_circle_fill,
            //     size: 26.0,
            //     color: Colors.white,// add custom icons also
            //   ),
            // ),

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications_rounded),
                tooltip: 'Comment Icon',
                onPressed: () {},
              ), //IconButton

            ], //<Widget>[]

          ),


           body: ListView(
             // scrollDirection:Axis.vertical,
             // mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.start,
             padding: const EdgeInsets.fromLTRB(22,29,10,2),
                 children: [

             Text(   'JOBS',
             style: TextStyle(
               fontFamily: 'RobotoSlab',
               color:Colors.red,
               fontSize: 20.0,
               letterSpacing:0.6,
               fontWeight: FontWeight.bold,
             ),),
                   // Padding(padding: const EdgeInsets.all(16.0),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0,6,9,33),
                        // Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
                        // child:FittedBox(
                          child: Material(
                              color: Colors.white,
                               elevation:5.0,

                           // borderRadius: BorderRadius.circular(5.0),
                          shadowColor: Colors.white,
                              child: Column(
                                  children:[
                                    Row(
                                      children:[
                                        Padding(
                                          padding: EdgeInsets.only(left: 12)),
                                        Icon( Icons.work,color: Colors.blueGrey,size: 23),
                                        SizedBox(width: 20),
                                        Text(   'Job History',
                                          style: TextStyle(fontFamily: 'RobotoSlab', color:Colors.grey[600], fontSize: 12.0, letterSpacing:0.6,),
                                        ),
                                    ],),
                                    Divider(height: 21.0, color: Colors.white,),
                                    Row(
                                      children:[
                                        Padding(
                                          padding: EdgeInsets.only(left: 12.0),),
                                        Icon( FontAwesomeIcons.creditCard,color: Colors.blueGrey,size: 23,),
                                        SizedBox(width: 20),
                                        Text(   'Credit Balance',
                                          style: TextStyle(fontFamily: 'RobotoSlab', color:Colors.grey[600], fontSize: 12.0, letterSpacing:0.6,),
                                        ),
                                      ],),
                                    Divider(height: 21.0, color: Colors.white,),
                                    Row(
                                      children:[
                                        Padding(
                                          padding: EdgeInsets.only(left: 12.0),),
                                        Icon( Icons.wysiwyg_outlined,color: Colors.blueGrey,size: 23),
                                        SizedBox(width: 20),
                                        Text(   'Insurance',
                                          style: TextStyle(fontFamily: 'RobotoSlab', color:Colors.grey[600], fontSize: 12.0, letterSpacing:0.6,),
                                        ),
                                      ],),
                                ],),

                          ),
                     ),
                   Text(   'ACCOUNT',
                     style: TextStyle(fontFamily: 'RobotoSlab', color:Colors.red, fontSize: 20.0, letterSpacing:0.6, fontWeight: FontWeight.bold,),
                   ),
                   // Padding(padding: const EdgeInsets.all(16.0),
                   Container(
                     padding: const EdgeInsets.fromLTRB(0, 6 , 9, 33),
                     // child:FittedBox(
                     child: Material(
                       color: Colors.white,
                       elevation:5.0,
                       // borderRadius: BorderRadius.circular(5.0),
                       shadowColor: Colors.white,
                       child: Column(
                         children:[
                           Row(
                             children:[
                               Padding(
                                 padding: EdgeInsets.only(left: 12.0),),
                               Icon( FontAwesomeIcons.language,color: Colors.blueGrey,size: 23),
                               SizedBox(width: 20),
                               Text(   'Select Language',
                                 style: TextStyle(fontFamily: 'RobotoSlab', color:Colors.grey[600], fontSize: 12.0, letterSpacing:0.6,),
                               ),

                             ],),
                           Divider(height: 21.0, color: Colors.white,),
                           Row(
                             children:[
                               Padding(
                                 padding: EdgeInsets.only(left: 12.0),),
                               Icon(Icons.comment_bank,color: Colors.blueGrey,size: 23,),
                               SizedBox(width: 20),
                               Text(   'GST,PAN,Bank Details',
                                 style: TextStyle(
                                   fontFamily: 'RobotoSlab',
                                   color:Colors.grey[600],
                                   fontSize: 12.0,
                                   letterSpacing:0.6,
                                   // fontWeight: FontWeight.bold,
                                 ),
                               ),

                             ],),
                           Divider(
                             height: 21.0,
                             color: Colors.white,
                           ),
                           Row(
                             children:[
                               Padding(
                                 padding: EdgeInsets.only(left: 12.0),),
                               Icon( Icons.settings,color: Colors.blueGrey,size: 23),
                               SizedBox(width: 20),
                                 Text(   'Account Settings',
                                 style: TextStyle(
                                   fontFamily: 'RobotoSlab',
                                   color:Colors.grey[600],
                                   fontSize: 12.0,
                                   letterSpacing:0.6,
                                   // fontWeight: FontWeight.bold,
                                 ),
                               ),

                             ],),
                         ],),


                     ),
                   ),
                   Text(   'APP',
                     style: TextStyle(
                       fontFamily: 'RobotoSlab',
                       color:Colors.red,
                       fontSize: 20.0,
                       letterSpacing:0.6,
                       fontWeight: FontWeight.bold,
                     ),),
                   // Padding(padding: const EdgeInsets.all(16.0),
                   Container(
                     padding: const EdgeInsets.fromLTRB(0, 6 , 9, 0),
                     // child:FittedBox(
                     child: Material(
                       color: Colors.white,
                       elevation:5.0,
                       // borderRadius: BorderRadius.circular(5.0),
                       shadowColor:Colors.white,
                       child: Column(
                         children:[
                           Row(
                             children:[
                               Padding(
                                 padding: EdgeInsets.only(left: 12.0),),
                               Icon( Icons.policy,color: Colors.blueGrey,size: 23),
                               SizedBox(width: 20),
                               Text(   'Terms of Use',
                                 style: TextStyle(
                                   fontFamily: 'RobotoSlab',
                                   color:Colors.grey[600],
                                   fontSize: 12.0,
                                   letterSpacing:0.6,
                                   // fontWeight: FontWeight.bold,
                                 ),
                               ),

                             ],),
                           Divider(
                             height: 21.0,
                             color: Colors.white,
                           ),
                           Row(

                             children:[
                               Padding(
                                 padding: EdgeInsets.only(left: 12.0),),
                               Icon( Icons.remove_red_eye_sharp,color: Colors.blueGrey,size: 23),
                               SizedBox(width: 20),
                               Text(   'Privacy Policy',
                                 style: TextStyle(
                                   fontFamily: 'RobotoSlab',
                                   color:Colors.grey[600],
                                   fontSize: 12.0,
                                   letterSpacing:0.6,
                                   // fontWeight: FontWeight.bold,
                                 ),
                               ),

                             ],),
                           Divider(
                             height: 21.0,
                             color: Colors.white,
                           ),
                           Row(
                             children:[
                               Padding(
                                 padding: EdgeInsets.only(left: 12.0),),
                               Icon( Icons.download_sharp,color: Colors.blueGrey,size: 23),
                               SizedBox(width: 20),
                               Text(   'Download our Kleen Company Customer App',
                                 style: TextStyle(
                                   fontFamily: 'RobotoSlab',
                                   color:Colors.grey[600],
                                   fontSize: 12.0,
                                   letterSpacing:0.6,
                                   // fontWeight: FontWeight.bold,
                                 ),
                               ),

                             ],),
                         ],),


                     ),
                   ),

                 ], ),


       ),
        );
  }
}
