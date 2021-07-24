import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:service_wallet_vender/home/home_dashbord.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:service_wallet_vender/DatabaseConection/create_new_service.dart';




class DescriptionVendor extends StatefulWidget {

  String approvelid,aid,uid,mobileno;


  DescriptionVendor(this.approvelid, this.aid, this.uid, this.mobileno);

  @override
  _DescriptionVendorState createState() => _DescriptionVendorState(approvelid,aid,uid,mobileno);
}

class _DescriptionVendorState extends State<DescriptionVendor> {

  String approvelid,aid,uid,mobileno;


  _DescriptionVendorState(this.approvelid, this.aid, this.uid, this.mobileno);

  TextEditingController _textEditingController,_textEditingControllertitle;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0,0,102, 1),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.fromLTRB(10,60,10,10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            SizedBox(height: 0,),
                            TextFormField (
                              controller: _textEditingControllertitle,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              maxLength: 50,
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1)
                                ),
                                hintText: "Service title",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),

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
                            SizedBox(height: 20,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: _selectedService,
                                  items: _dropdownItem,
                                  onChanged: onChangeDropdown,
                                ),
                              ),
                              decoration: BoxDecoration(border: Border.all(width: 1,color: Color.fromRGBO(0,0,102, 1)),borderRadius: BorderRadius.circular(4)),
                              padding: EdgeInsets.fromLTRB(8,6, 8, 2),
                            ),
                            SizedBox(height: 20,),
                            TextFormField (
                              controller: _textEditingController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              maxLength: 300,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1)
                                ),
                                hintText: "description",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1,color: Color.fromRGBO(0,0,102, 1))
                                ),
                              ),
                            ),
                            SizedBox(height: 60,),

                          ],
                        ),
                      ),
                    ),
                  ],),
              )
          ),
          getContainerForPrice(),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  List<Car> _companies = Car.getCompanies();
  List<DropdownMenuItem<Car>> _dropdownMenuItems;
  Car _selectedCompany;

  List<ServiceName> _name = ServiceName.getServices();
  List<DropdownMenuItem<ServiceName>> _dropdownItem;
  ServiceName _selectedService;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;

    _dropdownItem=  buildDropdownMenuItem1(_name);
    _selectedService = _dropdownItem[0].value;

    _textEditingController = new TextEditingController();
    _textEditingControllertitle = new TextEditingController();
  }


  List<DropdownMenuItem<Car>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Car>> items = List();
    for (Car country in companies) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }


  List<DropdownMenuItem<ServiceName>> buildDropdownMenuItem1(List services) {
    List<DropdownMenuItem<ServiceName>> item = List();
    for (ServiceName job in services) {
      item.add(
        DropdownMenuItem(
          value: job,
          child: Text(job.service),
        ),
      );
    }
    return item;
  }
  onChangeDropdownItem(Car selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }
  onChangeDropdown(ServiceName selectedService) {
    setState(() {
      _selectedService = selectedService;
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
                        color: Color.fromRGBO(0,0,102, 1),
                        elevation: 0,
                        onPressed: (){
                          // if(_formKey.currentState.validate()){
                          //   CreateNewService cns = new CreateNewService(approvelid,aid,uid,mobileno,_selectedCompany.name,_selectedService.service,_textEditingController.text,"date","time","0","true",_textEditingControllertitle.text,"0",UUID.getUUID());
                          //
                          //   cns.create_new_service().then((value){
                          //     if(value != null)
                          //     {
                          //       Fluttertoast.showToast(
                          //         msg: "Service create Succesfully",
                          //         toastLength: Toast.LENGTH_SHORT,
                          //         gravity: ToastGravity.BOTTOM,
                          //         timeInSecForIosWeb: 1,
                          //         backgroundColor: Color.fromRGBO(0, 0, 102, 1),
                          //         textColor: Colors.white,
                          //         fontSize: 16.0,
                          //       );
                          //       Timer(
                          //         Duration(seconds: 1),(){
                          //         Navigator.pop(context);
                          //         }
                          //       );
                          //     }
                          //     else {
                          //       Fluttertoast.showToast(
                          //         msg: "Some thing went wrong",
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => A()),
                          // );
                        },
                        child: Text("SUBMIT", style: TextStyle(fontFamily: 'RobotoSlab', letterSpacing: 0.6, color: Colors.white), ),
                      )
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class Car {
  int id;
  String name;
  Car(this.id, this.name);

  static List<Car> getCompanies() {
    return <Car>[
      Car(0, 'Car Type'),
      Car(1, 'HATCHBACK'),
      Car(2, 'SEDAN'),
      Car(3, 'SUB-COMPACT SUV'),
      Car(4, 'MUV-SUV'),
      Car(5, 'LUXURY'),

    ];
  }
}
class ServiceName {
  int id;
  String service;

  ServiceName(this.id, this.service);

  static List<ServiceName> getServices() {
    return <ServiceName>[
      ServiceName(0, 'Service Name'),
      ServiceName(1, 'Car Repairing'),
      ServiceName(2, 'Car Washing'),
      ServiceName(3, 'Denting and Painting'),
      ServiceName(4, 'Tyres and Wheel Care'),
      ServiceName(5, 'Batteries'),
      ServiceName(6, 'Lights and Fitments'),
      ServiceName(7, 'Windshields and Glass'),
      ServiceName(8, 'Equipment Installing'),
      ServiceName(9, 'Tyres and Wheel Care'),
    ];
  }
}
