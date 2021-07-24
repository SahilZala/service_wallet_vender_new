import 'dart:convert';
import 'dart:io';

class CreateNewUser
{
  String userid,name,mail,city,address,lat,log,mobileno,time,date,profile,activation;


  CreateNewUser(
      this.userid,
      this.name,
      this.mail,
      this.city,
      this.address,
      this.lat,
      this.log,
      this.mobileno,
      this.time,
      this.date,
      this.profile,
      this.activation);

  Future<Map> create()
  async {


  }



  Future<Map> checkMobile(String mobileno)
  async {

  }


  Future<List> getData()
  async {

  }

  Future<String> uploadProfileImage(File _image)
  async {

  }

  String getProfile()
  {
    return profile;
  }

  void setProfile(String profile)
  {
    this.profile = profile;
  }




  void checkMobileNoNew() async{

  }

}

