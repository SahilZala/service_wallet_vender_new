import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_wallet_vender/DatabaseConection/create_approvel.dart';
import 'package:service_wallet_vender/DatabaseConection/fetch_current_userdata.dart';
import 'package:service_wallet_vender/DatabaseConection/upload_image.dart';
import 'package:service_wallet_vender/for_aprovel/file_upload.dart';
import 'package:service_wallet_vender/last_page.dart';
import 'package:service_wallet_vender/orders/orders.dart';
import 'package:service_wallet_vender/service_app/description_vendor.dart';
import 'TrainCenter.dart';
import 'package:service_wallet_vender/DatabaseConection/fetch_my_service.dart';
import 'package:service_wallet_vender/home/edit_address.dart';
import 'package:service_wallet_vender/DatabaseConection/active_deactive.dart';
import 'package:service_wallet_vender/DatabaseConection/orders_connection.dart';

class HomeDashbord extends StatefulWidget
{
  Map data;

  HomeDashbord(this.data);

  _HomeDashbord createState() => _HomeDashbord(data);
}

class _HomeDashbord extends State<HomeDashbord> {


  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  Map data, approvel_data;
  List myAppointments = new List();
  List<Widget> myAppointmentsWidget = new List();

  _HomeDashbord(this.data);

  int _selectedIndex = 1;
  List<Widget> _widgetOptions;

  File _image = null;

  var picker = ImagePicker();
  List rectifydata = new List();

  _imgFromGallery() async {
    try {
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }
    catch (e) {
      print(e);
    }
  }


  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  int ordersStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAppointments.clear();
    myAppointmentsWidget.clear();


  }

  FetchMyService fms = new FetchMyService();

  OrdersConnection oc = new OrdersConnection();
  

  int count = 0;

  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      getListOfService(),
      getHome(),
      Container(),
      //getMapScreen(),
      Container()
      //getAppointmentList()

      
    ];

    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Color.fromRGBO(0, 0, 102, 1),
        elevation: 14.0,

        actions: <Widget>[

          IconButton(
              icon: Icon(Icons.refresh, color: Colors.white,), onPressed: () {
          //  checkAprovel();
          }),

          IconButton(
            icon: Icon(Icons.notifications_rounded),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Setting Icon',
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Last_Page(),
                  ),
                ),
          ), //IconButton
        ], //<Widget>[]

      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromRGBO(0, 0, 102, 1),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (value) {
          // Respond to item press.
          setState(() => _selectedIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            title: Text('NEW', style: TextStyle(
              fontFamily: 'RobotoSlab', color: Colors.grey[600],),),
            icon: Icon(Icons.mail),
          ),
          BottomNavigationBarItem(
            title: Text('DASHBORD', style: TextStyle(
              fontFamily: 'RobotoSlab', color: Colors.grey[600],),),
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            title: Text('KC around you', style: TextStyle(
              fontFamily: 'RobotoSlab', color: Colors.grey[600],),),
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            title: Text('Appointment', style: TextStyle(
              fontFamily: 'RobotoSlab', color: Colors.grey[600],),),
            icon: Icon(Icons.cleaning_services),
          ),
        ],
      ),


      body: Container(
        margin: new EdgeInsets.all(10),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getHome() {
    return Column(
      children: [
        getFirstBanner(),
        getMenuBanners(
          "Training Center", "video about how to start with service",
          openTrainCenter,),
        getMenuBanners(
          "Onboarding Documents", "Pan, Address Proof, Documents for loan",
          openDocumnetUpload,),
        getMenuBanners("About me", "Details about me", updateUserProfile),
        getMenuBanners(
            "Bank Details", "Payout will be deposited in your account",
            openTrainCenter),
        _for_approve == 0 ? getContainerForPrice() : approvel_status != null
            ? approvel_status['approved'] == "true" ? Column(children: [
          getMenuBanners("Create Services", "create services which you can",
              openCreateService),
          approvelDone(),
        ],) : SizedBox()
            : SizedBox(),
      ],
    );
  }

  Widget getFirstBanner() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile Progress", style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Color.fromRGBO(0, 0, 102, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text("Complete the below steps to", style: TextStyle(
                    color: Color.fromRGBO(0, 0, 102, 1), fontSize: 15),
                  textAlign: TextAlign.start,),
                SizedBox(height: 5,),
                Text("Become a KC Partner", style: TextStyle(
                    color: Color.fromRGBO(0, 0, 102, 1), fontSize: 15),
                  textAlign: TextAlign.start,)
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              //_showPicker(context);
            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color.fromRGBO(52, 73, 94, 1))
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: Container(
                  decoration: BoxDecoration(
                      // image: DecorationImage(
                      //     image: NetworkImage(data['profile']),
                      //     onError: (object, val) {
                      //       return NetworkImage(
                      //           "https://cdn.dnaindia.com/sites/default/files/styles/full/public/2020/06/13/909277-ima-pop.jpg");
                      //     }
                      //),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMenuBanners(String s1, String s2, callFunc) {
    return GestureDetector(
      onTap: () {
        callFunc();
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s1, style: TextStyle(
                                color: Color.fromRGBO(52, 73, 94, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text(s2, style: TextStyle(
                                color: Color.fromRGBO(52, 73, 94, 1),
                                fontSize: 12),)
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Icon(Icons.navigate_next, size: 30,
                        color: Color.fromRGBO(52, 73, 94, 1),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget getContainerForPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15),
                        elevation: 0,
                        onPressed: () {},
                        child: Text(
                          "Submit for Approval",
                          style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 20,
                              color: Color.fromRGBO(0, 0, 102, 1)
                          ),
                        ),
                        // color: Color.fromRGBO(0, 0, 102, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                          side: BorderSide(color: Color.fromRGBO(0, 0, 102, 1)),
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget getMapScreen() {
  //   print("test");
  //   var par = DateTime.parse("2021-05-15");
  //
  //   print(par.isBefore(DateTime.now()));
  //
  //   return FutureBuilder(builder: (ctx,snapshot){
  //
  //     if(snapshot.connectionState == ConnectionState.done)
  //     {
  //       if(snapshot.hasError)
  //       {
  //         return Text("error");
  //       }
  //       else if(snapshot.hasData) {
  //
  //         return FutureBuilder(builder: (ctx,snapshot1){
  //           if(snapshot1.connectionState == ConnectionState.done) {
  //             if (snapshot1.hasError) {
  //               return Text("error");
  //             }
  //             else if(snapshot1.hasData){
  //               rectifydata.clear();
  //
  //               for(int i=0;i<snapshot.data.length;i++)
  //               {
  //                 for(int j=0;j<snapshot1.data.length;j++)
  //                 {
  //                   if(snapshot.data[i]['cartype'] == snapshot1.data[j]['cartype'] && snapshot.data[i]['servicename'] == snapshot1.data[j]['servicename'])
  //                   {
  //
  //                     print("jjj");
  //                     print(i);
  //                     print(snapshot.data[i]);
  //                     print(snapshot1.data[j]);
  //
  //                     var par = DateTime.parse(snapshot1.data[j]['ondate'].toString());
  //
  //                     print(par.isAfter(DateTime.now()));
  //
  //                     if(par.isAfter(DateTime.now()) || (par.day == DateTime.now().day && par.month == DateTime.now().month && par.year == DateTime.now().year)) {
  //                       rectifydata.add(snapshot1.data[j]);
  //                       // print("ghghgh");
  //                       // print(rectifydata);
  //                       // print(rectifydata.length);
  //                     }
  //                   }
  //                 }
  //               }
  //
  //               return Column(children: getOrdersList());
  //             }
  //           }
  //           return CircularProgressIndicator();
  //         },future:  oc.showOrders(data['id'], data["mobileno"],double.parse(data['lat']),double.parse(data['log'])),);
  //       }
  //     }
  //
  //
  //     return CircularProgressIndicator();
  //   },future: oc.getData(data['id'], data['mobileno']),);
  //   // return Column(
  //   //   children: ordersStatus == 1 ? getOrdersList() : [Text("sasa")],
  //   // );
  // }

  int _for_approve = 0;
  Map approvel_status = null;

  // void checkAprovel() {
  //   CreateApprovel ca = new CreateApprovel(
  //       "approvelid",
  //       "aid",
  //       "uid",
  //       "mobileno",
  //       "panurl",
  //       "adharurl",
  //       "adharbackurl",
  //       "date",
  //       "time",
  //       "approved");
  //   ca.checkMobile(data['mobileno']).then((value) {
  //     if (value != null) {
  //       setState(() {
  //         approvel_data = value;
  //         approvel_status = value;
  //         _for_approve = 1;
  //       });
  //     }
  //     else {
  //       setState(() {
  //         _for_approve = 0;
  //       });
  //     }
  //   });
  // }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void openTrainCenter() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TrainCenter()));
  }

  void openCreateService() {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        DescriptionVendor(approvel_data['id'], data['id'], data['userid'],
            data['mobileno'])));
  }

  void openDocumnetUpload() {
    if (_for_approve == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          ImageUpload(data['id'], data['userid'], data['mobileno'], data)));
    }
    else {
      Fluttertoast.showToast(
        msg: "Applied for approvel",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(0, 0, 102, 1),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  Widget approvelDone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      child: RaisedButton(
                        onPressed: (){},
                        padding: EdgeInsets.all(15),
                        elevation: 0,
                        child: Text(
                          "Your Request Approved",
                          style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 20,
                              color: Color.fromRGBO(0, 0, 102, 1)
                          ),
                        ),
                        // color: Color.fromRGBO(0, 0, 102, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                          side: BorderSide(color: Color.fromRGBO(0, 0, 102, 1)),
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }


  void updateUserProfile() {

    scaffoldkey.currentState.showBottomSheet((context) {
      return Container();
    }).closed.whenComplete(() {
      print("bottom sheet colosed");
    });
  }

  // Widget getUpdateWidget()
  // {
  //   return
  // }


  List<Widget> service_i_have = new List();

  // void get_data() async {
  //   const onCreateMessage = '''subscription onCreateService {
  //     onCreateService {
  //       servicename
  //     }
  //   }''';
  //
  //   var a = await Amplify.API.subscribe(
  //       request: GraphQLRequest(document: onCreateMessage),
  //       onData: (data) {
  //         setState(() {
  //           fms.getData(this.data['userid'], this.data['mobileno']).then((
  //               value) {
  //             service_i_have.clear();
  //             setState(() {
  //               for (int i = 0; i < value.length; i++) {
  //                 service_i_have.add(getListView(value.elementAt(i), i));
  //               }
  //             });
  //           });
  //         });
  //       },
  //       onEstablished: () {
  //         print("establish");
  //       },
  //       onError: (onError) {
  //         print(onError);
  //       },
  //       onDone: () {});
  //   print(a.hashCode);
  // }


  Widget getListOfService() {
    return Column(children: service_i_have,);
  }

  Widget getListView(Map val, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text((index + 1).toString()),
            foregroundColor: Colors.white,
          ),
          title: Text(val["servicename"]),
          subtitle: Text(val["cartype"]),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
            caption: val['activation'] == "true" ? 'Deactivate' : 'Activate',
            color: Colors.blue,
            icon: val['activation'] == "true" ? Icons.close : Icons.check,
            onTap: () {
              if(val['activation'].toString() == "true")
              {
                activeDeactive(val['mobileno'], val['id'],"false");
              }
              else{
                activeDeactive(val['mobileno'], val['id'],"true");
              }
            }
        ),

      ],
      secondaryActions: <Widget>[
        // IconSlideAction(
        //     caption: 'Edit',
        //     color: Colors.black45,
        //     icon: Icons.edit,
        //     onTap: () => {}
        // ),
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => {
              deleteService(val['id'],val['mobileno'], val['serviceid'])
            }
        ),
      ],
    );
  }

  void activeDeactive(String mobileno,String id,String active)
  {
    // ActiveDeactive ad  = new ActiveDeactive();
    // ad.activeDeactive(mobileno, id, active).whenComplete((){
    //   setState(() {
    //     fms.getData(this.data['userid'], this.data['mobileno']).then((value) {
    //       service_i_have.clear();
    //       setState(() {
    //         for (int i = 0; i < value.length; i++) {
    //           service_i_have.add(getListView(value.elementAt(i), i));
    //         }
    //       });
    //     });
    //   });
    // });
  }

  void deleteService(String id,String mobileno,String serviceid)
  {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Delete?'),
        message: const Text('delete given service.'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context);

            },
          ),
          CupertinoActionSheetAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  List<Widget> ordersWidgetList = new List();


  List<Widget> getOrdersList()
  {
    ordersWidgetList.clear();
    for(int i=0;i<rectifydata.length;i++)
    {
      ordersWidgetList.add(getOrdersWidget(rectifydata[i]));
    }
    return ordersWidgetList;
  }

  Widget getOrdersWidget(odata)
  {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersClass(odata, data),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: EdgeInsets.all(10),

            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(odata['servicename'],
                  style: TextStyle(
                  color: Color.fromRGBO(52, 73, 94, 1),
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 10,),

                Text(odata['address'],
                  style: TextStyle(
                    color: Color.fromRGBO(52, 73, 94, 1),
                    fontSize: 16
                  ),
                ),

                SizedBox(height: 10,),

                Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),

                SizedBox(height: 15,),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(odata['ondate']+' - '+odata['ontime'],style: TextStyle(color: Colors.blueGrey,),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Rs. "+odata['price']+" /-",textAlign: TextAlign.end,style: TextStyle(color: Colors.blueGrey,fontSize: 18,fontWeight: FontWeight.bold,),
                      ),

                    )
                  ],
                ),


                SizedBox(height: 15,),




              ],
            ),
          ),
        ),
      ),
    );
  }
  // Widget getAppointmentList()
  // {
  //   return FutureBuilder(builder: (ctx,snapshot){
  //
  //     if(snapshot.connectionState == ConnectionState.done)
  //     {
  //       if(snapshot.hasError)
  //       {
  //         return Text("error");
  //       }
  //       else if(snapshot.hasData) {
  //         print("this is snap");
  //         print(snapshot.data);
  //
  //
  //
  //         myAppointments = snapshot.data;
  //         createMyAppointmentWidgetList();
  //         return Column(
  //           children: returnMyAppointmentsWidgetList(),
  //         );
  //       }
  //     }
  //
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },future: getMyAppointmentList(data['userid']),);
  //   // return Column(
  //   //   mainAxisAlignment: MainAxisAlignment.start,
  //   //   crossAxisAlignment: CrossAxisAlignment.center,
  //   //   children: myAppointmentsWidget.isNotEmpty ? returnMyAppointmentsWidgetList() : [Text("no data")],
  //   // );
  // }

  void createMyAppointmentWidgetList()
  {
    myAppointmentsWidget.clear();
    for(int i=0;i<myAppointments.length;i++)
    {
      var par = DateTime.parse(myAppointments[i]['ondate'].toString());

      print(par.isAfter(DateTime.now()));
      if(par.isAfter(DateTime.now()) || (par.day == DateTime.now().day && par.month == DateTime.now().month && par.year == DateTime.now().year)) {
        myAppointmentsWidget.add(getMyAppointmentWidgetList(myAppointments[i]));
      }
    }
  }

  List<Widget> returnMyAppointmentsWidgetList()
  {
    return myAppointmentsWidget;
  }

  Widget getMyAppointmentWidgetList(Map myAppointData)
  {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: EdgeInsets.all(10),

            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(myAppointData['servicename'],
                  style: TextStyle(
                      color: Color.fromRGBO(52, 73, 94, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 10,),

                Text(myAppointData['address'],
                  style: TextStyle(
                      color: Color.fromRGBO(52, 73, 94, 1),
                      fontSize: 16
                  ),
                ),

                SizedBox(height: 10,),

                Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),

                SizedBox(height: 15,),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(myAppointData['ondate']+' - '+myAppointData['ontime'],style: TextStyle(color: Colors.blueGrey,),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Rs. "+myAppointData['price']+" /-",textAlign: TextAlign.end,style: TextStyle(color: Colors.blueGrey,fontSize: 18,fontWeight: FontWeight.bold,),
                      ),

                    )
                  ],
                ),


                SizedBox(height: 15,),




              ],
            ),
          ),
        ),
      ),
    );
  }



}






class NewBottomSheet extends StatefulWidget{
  String mobileno;
  _NewBottomSheet createState() => _NewBottomSheet(mobileno);

  NewBottomSheet(this.mobileno);
}

class _NewBottomSheet extends State<NewBottomSheet> {
  String mobileno = "";

  _NewBottomSheet(this.mobileno);

  int show_progress = 0;

  TextEditingController _nameEditingController;
  TextEditingController _emailEditingController;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 100,
        child: Container(
          color: Color.fromRGBO(222, 222, 222, 1),
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),

            child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Text(
                      "Edit Profile",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromRGBO(0, 0, 102, 1),
                        fontFamily: "RobotoSlab",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 20, width: 0,),

                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Color.fromRGBO(52, 73, 94, 1))
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameEditingController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)
                              ),
                              labelText: "Name",
                              // fillColor: Color.fromRGBO(0,0,102, 1),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1,
                                      color: Color.fromRGBO(0, 0, 102, 1))
                              ),
                            ),
                          ),

                          SizedBox(height: 30,),

                          TextFormField(
                            controller: _emailEditingController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)
                              ),
                              labelText: "Email",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1,
                                      color: Color.fromRGBO(0, 0, 102, 1))
                              ),
                            ),

                          ),

                          SizedBox(height: 30,),
                          showAdress(),
                          SizedBox(height: 30,),
                          getContainerForPrice(),


                        ],),

                    ),

                  )
                ]
                )
            )
        )
    );
  }

  File _image = null;

  var picker = ImagePicker();

  _imgFromGallery() async {
    try {
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }
    catch (e) {
      print(e);
    }
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget getContainerForPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(

          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 102, 1),
            borderRadius: BorderRadius.all(Radius.circular(5)),

          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [

              Expanded(
                  child: Container(
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: () {
                          if(_formKey.currentState.validate())
                          {
                            String name = _nameEditingController.text;
                            String email = _emailEditingController.text;

                            updateUserData(name, email);
                          }
                        },
                        child: Text("SUBMIT", style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            letterSpacing: 0.6,
                            color: Colors.white),),
                        color: Color.fromRGBO(0, 0, 102, 1),
                      )
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget showAdress() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your current Location ",
            style: TextStyle(
              fontFamily: "RobotoSlab",
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 0, 102, 1),
              fontSize: 18,
            ),
          ),


          GestureDetector(

            onTap: () {
              print(data['id']);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                    EditAddress(data['mobileno'], data['id'])),
              );
            },

            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  data == null ? "location" :
                  data['address'],

                  style: TextStyle(
                    color: Color.fromRGBO(45, 45, 45, 1),
                    fontSize: 18,
                    fontFamily: "RobotoSlab",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map data = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FetchUserData fd = new FetchUserData();

    _nameEditingController = new TextEditingController();
    _emailEditingController = new TextEditingController();

    //  fetchUserData();
    fd.fetchData(mobileno).then((value) {
      setState(() {
        data = value;

        setState(() {
          _nameEditingController.text = data['name'];
          _emailEditingController.text = data['mail'];
        });

      });
    });

  }


  Future<void> fetchUserData() async {
    // String graphQLDocument = '''
    //     subscription MySubscription {
    //     onUpdateUserData {
    //        lat
    //        log
    //        address
    //        mobileno
    //     }
    //   }
    // ''';
    //
    //
    // var operation = Amplify.API.subscribe(
    //     request: GraphQLRequest<String>(document: graphQLDocument),
    //     onData: (event) {
    //       print('Subscription event data received: ${event.data}');
    //     },
    //     onEstablished: () {
    //       print('Subscription established');
    //     },
    //     onError: (e) {
    //       print('Subscription failed with error: $e');
    //     },
    //     onDone: () {
    //       print('Subscription has been closed successfully');
    //     });
  }

  void updateUserData(String username,String email)
  {
    // if(_image != null)
    // {
    //   UploadImageToAmplify uia = new UploadImageToAmplify();
    //   uia.uploadProfileImage(_image).then((value){
    //
    //   });
    // }
    // else {
    //
    // }
  }

}


