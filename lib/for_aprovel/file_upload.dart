import 'dart:io';

import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_wallet_vender/DatabaseConection/create_approvel.dart';
import 'package:service_wallet_vender/home/home_dashbord.dart';

import '../last_page.dart';
import 'package:service_wallet_vender/DatabaseConection/upload_image.dart';

class ImageUpload extends StatelessWidget {

  String aid,uid,mobileno;

  Map data;

  ImageUpload(this.aid, this.uid, this.mobileno, this.data);

  @override
  Widget build(BuildContext context) {
    return ImageUploads(aid,uid,mobileno,data);
  }
}

class ImageUploads extends StatefulWidget {

  String aid,uid,mobileno;
  Map data;
  @override
  _ImageUploadsState createState() => _ImageUploadsState(aid,uid,mobileno,data);

  ImageUploads(this.aid, this.uid, this.mobileno,this.data);


}

class _ImageUploadsState extends State<ImageUploads> {

  String aid,uid,mobileno;

  Map data;

  _ImageUploadsState(this.aid, this.uid, this.mobileno,this.data);

  int _selectedIndex = 1;
  List<Widget> _widgetOptions;

  var picker = ImagePicker();
  _imgFromGallery(int i) async{
    try{
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      setState(() {
        if(i==0) {
          _pan_image = image;
        }
        else if(i==1) {
          _adhar_image = image;
        }
        else{
          _adhar_back_image = image;
        }
      });
    }
    catch(e)
    {
      print(e);
    }
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeDashbord(data)));
    return true;
  }
  File _pan_image = null,_adhar_image = null,_adhar_back_image = null;

  _imgFromCamera(int i) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      if(i==0) {
        _pan_image = image;
      }
      else if(i==1) {
        _adhar_image = image;
      }
      else{
        _adhar_back_image = image;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      Text('JOBS', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      getHome(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          backgroundColor:Color.fromRGBO(0,0,102,1),
          elevation:14.0,

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
        body: Stack(
          children: [
            Container(
              margin: new EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

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



            Center(child: show_progress == 1 ?  Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[100],
                strokeWidth: 6,
                valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 0, 102, 1),),

              ),
            ) : Center(child: SizedBox(),),)
          ],
        ),
      ),
    );
  }

  int show_progress = 0;

  Widget getHome()
  {
    return Container(
      color: Colors.white12,
      child: Column(
        children: [
          getBanner("Pan Card",0),
          getBanner("Adhar Card(Front)",1),
          getBanner("Adhar Card(Back)",2),
          getSubmit(),

        ],
      ),
    );
  }
  Widget getSubmit()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(80, 20, 80, 15),
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0,0,102, 1),
            borderRadius: BorderRadius.all(Radius.circular(5)),

          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [

              Expanded(
                  child: Container(
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: (){

                          uploadImage();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => GoogleMaps()),
                          // );
                        },
                        child: Text("UPLOAD", style: TextStyle(fontFamily: 'RobotoSlab', letterSpacing: 0.6, color: Colors.white), ),
                        color: Color.fromRGBO(0,0,102, 1),
                      )
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget getBanner(String s,int i)
  {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s,style: TextStyle(
                    fontFamily: 'RobotoSlab',color:Color.fromRGBO(0,0,102,1),fontSize: 20,fontWeight: FontWeight.bold),),
              ],
            ),

          SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[ FDottedLine(
                child: GestureDetector(
                  onTap: (){_showPicker(context,i);},
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        // border: Border.all(color: Color.fromRGBO(52, 73, 94, 1))
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: (_pan_image != null && i == 0) || (_adhar_image != null && i == 1) || (_adhar_back_image != null && i == 2)
                          ? ClipRRect(
                        // borderRadius: BorderRadius.circular(50),

                        child: Image.file(
                          i == 0 ? _pan_image : i == 1 ? _adhar_image : _adhar_back_image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                        ),
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
              ),
           ], ),
        ],
      ),
    );
  }




  void _showPicker(context,int v) {
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
                        _imgFromGallery(v);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(v);
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


   void uploadImage()
   {
     if(_pan_image != null && _adhar_image != null && _adhar_back_image != null){

       setState(() {

         show_progress = 1;
       });

     //   UploadImageToAmplify ui = new UploadImageToAmplify();
     //   ui.uploadProfileImage(_pan_image).then((value1) {
     //
     //     if(value1 != null)
     //     {
     //      ui.uploadProfileImage(_adhar_image).then((value2){
     //        if(value2 != null){
     //          ui.uploadProfileImage(_adhar_back_image).then((value3){
     //            if(value3 != null){
     //
     //              setState(() {
     //
     //                show_progress = 0;
     //              });
     //              CreateApprovel ca = new CreateApprovel(UUID.getUUID(),aid, uid, mobileno, value1,value2, value3, "date", "time", "false");
     //              ca.createApprovel();
     //              Fluttertoast.showToast(
     //                msg: "Upload Succesfuly",
     //                toastLength: Toast.LENGTH_SHORT,
     //                gravity: ToastGravity.BOTTOM,
     //                timeInSecForIosWeb: 1,
     //                backgroundColor: Color.fromRGBO(0, 0, 102, 1),
     //                textColor: Colors.white,
     //                fontSize: 16.0,
     //              );
     //            }
     //            else{
     //
     //              setState(() {
     //
     //                show_progress = 0;
     //              });
     //              Fluttertoast.showToast(
     //                msg: "!Opps, Try later",
     //                toastLength: Toast.LENGTH_SHORT,
     //                gravity: ToastGravity.BOTTOM,
     //                timeInSecForIosWeb: 1,
     //                backgroundColor: Colors.red[400],
     //                textColor: Colors.white,
     //                fontSize: 16.0,
     //              );
     //            }
     //          });
     //        }
     //        else{
     //
     //          setState(() {
     //
     //            show_progress = 0;
     //          });
     //          Fluttertoast.showToast(
     //            msg: "!Opps, Try later",
     //            toastLength: Toast.LENGTH_SHORT,
     //            gravity: ToastGravity.BOTTOM,
     //            timeInSecForIosWeb: 1,
     //            backgroundColor: Colors.red[400],
     //            textColor: Colors.white,
     //            fontSize: 16.0,
     //          );
     //        }
     //      });
     //     }
     //     else{
     //
     //       setState(() {
     //
     //         show_progress = 0;
     //       });
     //       Fluttertoast.showToast(
     //         msg: "!Opps, Try later",
     //         toastLength: Toast.LENGTH_SHORT,
     //         gravity: ToastGravity.BOTTOM,
     //         timeInSecForIosWeb: 1,
     //         backgroundColor: Colors.red[400],
     //         textColor: Colors.white,
     //         fontSize: 16.0,
     //       );
     //     }
     //   });
     // }
     // else{
     //   setState(() {
     //     show_progress = 0;
     //   });
     //   Fluttertoast.showToast(
     //     msg: "please select file",
     //     toastLength: Toast.LENGTH_SHORT,
     //     gravity: ToastGravity.BOTTOM,
     //     timeInSecForIosWeb: 1,
     //     backgroundColor: Colors.red[400],
     //     textColor: Colors.white,
     //     fontSize: 16.0,
     //   );
     }
   }

  // void openAccountDetails(){
  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountDetails()));
  // }
}