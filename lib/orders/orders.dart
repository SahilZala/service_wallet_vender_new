import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_wallet_vender/home/home_dashbord.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

class OrdersClass extends StatefulWidget
{
  Map orderData,vendorData;
  _OrdersClass createState() => _OrdersClass(orderData,vendorData);

  OrdersClass(this.orderData, this.vendorData);

}

class _OrdersClass extends State<OrdersClass> {
  Map orderData,vendorData;


  CameraPosition _cameraPosition;
  final Set<Marker> _markers = {};
  LatLng ll;

  Completer<GoogleMapController> _controller = Completer();
  _OrdersClass(this.orderData, this.vendorData);



  @override
  void initState() {
    ll = new LatLng(double.parse(orderData['lat']), double.parse(orderData['log']));
    _cameraPosition = new CameraPosition(target: ll ,zoom: 11);
    _markers.clear();
    _markers.add(Marker(markerId: MarkerId(ll.toString()),position: ll,infoWindow: InfoWindow(title: orderData['servicename'],snippet: "destination"),icon: BitmapDescriptor.defaultMarker));

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDashbord(vendorData),
          ),
        );
      },
      child: SafeArea(child:
        Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Text(orderData['servicename'],style: TextStyle(color: Color.fromRGBO(52, 73, 94, 1),fontSize: 25,fontWeight: FontWeight.bold)),
                    SizedBox(width: 10,),
                    Container(width: 1,height: 25,color: Colors.grey,),
                    SizedBox(width: 10,),
                    Text(orderData['cartype'],style: TextStyle(color: Color.fromRGBO(104,104,104, 1),fontSize: 20,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
               Container(
                 width: MediaQuery.of(context).size.width,
                 padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                 child: Row(
                   children: [
                     Text(
                       orderData['ontime'],
                       style: TextStyle(
                         color: Color.fromRGBO(104, 104, 104, 1),
                         fontSize: 18
                       ),
                     ),
                     SizedBox(
                       width: 5,
                     ),
                     Text(
                       '---',
                       style: TextStyle(
                           color: Color.fromRGBO(180, 52,52, 1),
                           fontSize: 18,
                       ),
                     ),
                     SizedBox(
                       width: 5,
                     ),
                     Text(
                       orderData['ondate'],
                       style: TextStyle(
                           color: Color.fromRGBO(104, 104, 104, 1),
                           fontSize: 18
                       ),
                     ),
                     SizedBox(
                       width: 5,
                     ),
                   ],
                 ),
               ),

               Container(
                 height: MediaQuery.of(context).size.height/1.7,
                 width: MediaQuery.of(context).size.width,
                 child: GoogleMap(
                   mapType: MapType.normal,

                   initialCameraPosition: _cameraPosition,
                   markers: _markers,
                   onCameraMove: (cameraPosition){},
                   onMapCreated: _onMapCreated,
                 ),
               ),


               SizedBox(height: 10,),
               getContainerForPrice(),
             ],
           ),
          ),
          appBar: AppBar(
            title: Text(
              "Order",
              style: TextStyle(
                color: Color.fromRGBO(0,0,102, 1),
                fontSize: 18,
                fontFamily: "sairasemi",

              ),
            ),

            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color.fromRGBO(0,0,102, 1)),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeDashbord(vendorData),
                ),
              )
            ),

            backgroundColor: Colors.white,
            elevation: 0,
          ),
        )
      ),
    );
  }
  _onMapCreated(GoogleMapController controller)
  {
    _controller.complete(controller);
  }

  Widget getContainerForPrice()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: (){

          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),

            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(52,73,94,1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],

            ),
            child: Text("Take this",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          ),
        ),
      ],
    );
  }



}