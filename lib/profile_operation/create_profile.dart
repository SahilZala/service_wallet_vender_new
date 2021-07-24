import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_wallet_vender/DatabaseConection/create_new_user.dart';
import 'package:service_wallet_vender/home/home_dashbord.dart';
import 'package:service_wallet_vender/DatabaseConection/create_profession.dart';

class CreateProfile extends StatefulWidget
{
  String _mobile_no;
  List<String> _profession_list;
  LatLng ll;
  String address = "";
  _CreateProfile createState () => _CreateProfile(_mobile_no,_profession_list,ll,address);

  CreateProfile(this._mobile_no, this._profession_list, this.ll, this.address);
}
class _CreateProfile extends State<CreateProfile>
{
  String _mobile_no;
  String _user_name;
  String _user_mail;
  List<String> _profession_list = null;
  LatLng ll;
  String address;


  _CreateProfile(this._mobile_no, this._profession_list, this.ll, this.address);

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(
       backgroundColor: Color.fromRGBO(0,0,102, 1),
       elevation: 0,
       // iconTheme: IconThemeData(color: Color.fromRGBO(0,0,102, 1)),
     ),

     body: Stack(
       children: [
         Container(
           padding: EdgeInsets.all(20),
           child: SingleChildScrollView(

               child: Column(

                 children: [

                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Text("Almost done!",
                     style:TextStyle(fontFamily: 'RobotoSlab', color: Color.fromRGBO(0,0,102, 1), fontWeight: FontWeight.bold, fontSize: 47,),
                     textAlign: TextAlign.start,
                   ),
                 ),

                 SizedBox(height: 4,),

                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Text("Tell us few things about yourself",
                     style:TextStyle( color: Color.fromRGBO(0,0,102, 1), fontWeight: FontWeight.bold, fontSize: 15,),

                     textAlign: TextAlign.start,
                   ),
                 ),

                   SizedBox(height: 15,),

                   GestureDetector(
                     onTap: (){_showPicker(context);},
                     child: Container(
                       alignment: Alignment.centerRight,
                       height: 100,
                       width: 100,
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: Color.fromRGBO(52, 73, 94, 1))
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

                 SizedBox(height: 10,),
                 Container(
                   padding: EdgeInsets.fromLTRB(10,10,10,10),
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
                                     borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
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
                                     borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
                                 ),
                               ),

                             ),

                         SizedBox(height: 30,),

                             Container(
                               width: MediaQuery.of(context).size.width,
                               child: DropdownButtonHideUnderline(
                                 child: DropdownButton(
                                   value: _selectedCompany,
                                   items: _dropdownMenuItems,
                                   onChanged: onChangeDropdownItem,
                                 ),
                               ),
                               decoration: BoxDecoration(border: Border.all(width: 1,color: Color.fromRGBO(0,0,102, 1)),borderRadius: BorderRadius.circular(4)),
                               padding: EdgeInsets.fromLTRB(8,6, 8, 2),
                             ),
                         SizedBox(height: 90,),


                       ],
                     ),
                   ),
                 )
               ],),
             )
           ),
         getContainerForPrice(),

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
   );
  }

  int show_progress = 0;

  TextEditingController _nameEditingController;
  TextEditingController _emailEditingController;
  final _formKey = GlobalKey<FormState>();

  List<City> _companies = City.getCompanies();
  List<DropdownMenuItem<City>> _dropdownMenuItems;
  City _selectedCompany;


  @override
  void initState() {
    _nameEditingController = TextEditingController();
    _emailEditingController = TextEditingController();

    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;


  }


  List<DropdownMenuItem<City>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<City>> items = List();
    for (City country in companies) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(City selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  Widget getContainerForPrice()
  {


    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 15),
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
                          setState(() {
                            show_progress = 1;

                          });
                          if(_formKey.currentState.validate()) {

                            _user_name = _nameEditingController.text;
                            _user_mail = _emailEditingController.text;

                            if (_image == null) {
                              setState(() {
                                show_progress = 0;
                              });

                              Fluttertoast.showToast(
                                msg: "please select image",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red[400],
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                            else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeDashbord({'map':'sasa'})),
                              );
                            }
                          }
                          else{
                            setState(() {
                              show_progress = 0;
                            });
                          }
                          },
                        child: Text("SUBMIT", style: TextStyle(fontFamily: 'RobotoSlab', letterSpacing: 0.6, color: Colors.white), ),
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

  File _image = null;

  var picker = ImagePicker();
  _imgFromGallery() async{

    try{
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }
    catch(e)
    {
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





}


class City {
  int id;
  String name;
  City(this.id, this.name);

  static List<City> getCompanies() {
    return <City>[

      City(1, 'PUNE'),
      City(2, 'DELHI'),
      City(3, 'Noida'),
      City(4, 'Gurgaon'),
      City(5, 'Banglore'),
      City(6, 'Jaipur'),
    ];
  }



}

// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // class LoginPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: loginPage(),
// //     );
// //   }
// // }
// // class loginPage extends StatefulWidget {
// //   @override
// //   _loginPageState createState() => _loginPageState();
// // }
// //
// // class _loginPageState extends State<loginPage> {
// //   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
// //
//        backgroundColor: Color.fromRGBO(0,0,102, 1),
//        elevation: 0,
//        // iconTheme: IconThemeData(color: Color.fromRGBO(0,0,102, 1)),
//      ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 50,),
//             // Container(
//             //   height: 70,
//             //   width: 70,
//             //   decoration: BoxDecoration(
//             //       image: DecorationImage(
//             //           image: AssetImage('asset/images/logo.png')
//             //       )
//             //   ),
//             // ),
//
//             Expanded(
//               child: Column(
//
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Container(
//
//                     child: Text("Almost done!",
//                       style:TextStyle(fontFamily: 'RobotoSlab', color: Color.fromRGBO(0,0,102, 1), fontWeight: FontWeight.bold, fontSize: 43,),
//                       textAlign: TextAlign.start,
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Text("Tell us few things about yourself",
//                       style:TextStyle( color: Color.fromRGBO(0,0,102, 1), fontWeight: FontWeight.w900, fontSize: 15,),
//                       textAlign: TextAlign.start,
//                     ),
//                   ),
//
//                   // Text("Please Log In to your Account ",style: TextStyle(
//                   //   fontWeight: FontWeight.w300,
//                   //   fontSize: 10,
//                   //   color: Colors.grey,
//                   //   fontFamily: 'sfpr',
//                   // ),),
//                   SizedBox(height: 30,),
//                   TextField(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderSide: BorderSide(width: 1)
//                       ),
//                         labelText: "Name",
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   TextField(
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1)
//                         ),
//                         labelText: "Email",
//                         focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
//                   ),
//                     ),
//
//                   ),
//                   SizedBox(height: 10,),
//                   TextField(
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1)
//                         ),
//                         labelText: "City",
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 30,),
//                   getContainerForPrice(),
//                 ], ),
//             ),
//
//
// /////
//
//
//
//
//
//   /////
//           ],
//         ),
//       ),
//     );
//   }
//   // void openSignUpPage(){
//   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
//   // }
//   // void openHomePage(){
//   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
//   // }
//
//   Widget getContainerForPrice()
//   {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           margin: EdgeInsets.fromLTRB(20, 20, 20, 15),
//           height: 50,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(0,0,102, 1),
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//
//           ),
//
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//
//               Expanded(
//                   child: Container(
//                       child: RaisedButton(
//                         elevation: 0,
//                         onPressed: (){
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Profession()),
//                           );
//                         },
//                         child: Text("SUBMIT", style: TextStyle(fontFamily: 'RobotoSlab', letterSpacing: 0.6, color: Colors.white), ),
//                         color: Color.fromRGBO(0,0,102, 1),
//
//                       )
//                   )
//               ),],),),],);}
// }



