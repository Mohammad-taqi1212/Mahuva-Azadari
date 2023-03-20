import 'dart:convert';
import 'package:mahuva_azadari/Screens/Admin%20Data/AdminPannel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../Models/GetUserData.dart';
import '../../Models/Hexa color.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AdminReq extends StatefulWidget {
  const AdminReq({Key? key}) : super(key: key);

  @override
  State<AdminReq> createState() => _AdminReqState();
}

class _AdminReqState extends State<AdminReq> {

  TextEditingController descriptionController = TextEditingController();
  String? description;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String? adminName;
  String? adminEmail;
  String? adminId;
  String? storeUserID;
  bool isLogin = false;
  String? storeUserName;
  bool showButton = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loginStatus();
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title:
        Text("Admin Request",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            //color: Colors.black
          ),
        ),
          centerTitle: true,
          backgroundColor: Color(hexColors('006064')),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              children: [
                Card(
                  color: Color(hexColors("00BCD4")),
                  //elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0)),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                      gradient: LinearGradient(
                          colors: [
                            //Color(hexColors("00BCD4")),
                            // Colors.red,
                            // Colors.pink,
                            Color(hexColors("00796B")),
                            Color(hexColors("26A69A")),
                            Color(hexColors("00BFA5")),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight
                      ),
                    ),
                    child: Text("Salamunalikum\n"
                        "SignUp request will be processed and approved"
                        "/Disapproved in 3 working days."
                        "  (એડમીન ની પ્રક્રિયા મંજૂર/નામંજૂર ૩ કામકાજના "
                        "દિવસોમાં થઈ જશે.)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     child: Text("Note : If you are already admin just write 'Admin' in description box",
                //     style: TextStyle(
                //       color: Colors.purple,
                //       fontWeight: FontWeight.bold
                //     ),),
                //   ),
                // ),
                // TextField(
                //   controller: descriptionController,
                //   cursorColor: Colors.blue,
                //   textCapitalization: TextCapitalization.words,
                //   style: TextStyle(
                //       fontWeight: FontWeight.w700,
                //       fontSize: 18),
                //   keyboardType: TextInputType.multiline,
                //   decoration: InputDecoration(
                //     hintText: "Description",
                //     labelText: "Description",
                //     border: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(15)),
                //   ),
                //   onChanged: (value) {
                //     description = value;
                //   },
                // ),
                SizedBox(
                  height: 10,
                ),
                SignInButton(
                    Buttons.GoogleDark,
                    elevation: 8,
                    text: "Sign Up/Sign In with email",
                    onPressed: () async{
                      FocusManager.instance.primaryFocus?.unfocus();
                      // if (descriptionController.text
                      //     .trim()
                      //     .isEmpty) {
                      //   Fluttertoast.showToast(
                      //       msg: "Please enter description",
                      //       backgroundColor: Color(hexColors("006064")));
                      // } else {
                      //   isSentRequest();
                      // }
                      isSentRequest();
                    }),

                Visibility(
                  visible: showButton,
                  child: TextButton(onPressed: () async{
                    _googleSignIn.signOut();
                    _googleSignIn.disconnect();
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    setState(() {
                      showButton = false;
                    });
                    Fluttertoast.showToast(msg: "Requested email is cleared"
                        ", Try to login or request",
                    backgroundColor: Color(hexColors("006064")));
                  },
                      child: Text("Clear requested email")),
                )
              ],
            ),
          ),
        ),

      ),
    );
  }


  // //google signin method
  googleLogin() async {
    try {
      var adminUser = await _googleSignIn.signIn();
      if (adminUser == null) {
        Fluttertoast.showToast(
            msg: "Registration failed",
            backgroundColor: Color(hexColors("006064")));
      } else {
        setState(() {
          adminName = adminUser.displayName;
          adminEmail = adminUser.email;
          adminId = adminUser.id;
        });
        //loading indicator
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: Image.asset('assets/Ovals.gif'),
              );
            });
        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
        sharedPreferences.setBool('isSentReq', true);
        sharedPreferences.setString('getUserName', adminName!);
        RegistarationUser();
      }
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: error.toString(),
          backgroundColor: Color(hexColors("006064")));
    }
  }

  Future<bool> showUnderProcessDailog(context) async {
    return await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          title: Center(
            child: Icon(Icons.check_circle_sharp,
              size: 50, color: Colors.green,),
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 250,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your admin request is already sent!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                  Text("Your admin request is already sent, it will"
                      " approve within 3 working days "
                      "for check your admin status please check here"),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("OK"),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    });
  }

  Future<bool> showWaitngPop(context) async {
    return await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          title: Center(
            child: Icon(Icons.check_circle_sharp,
              size: 50, color: Colors.green,),
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 250,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$adminName! Your admin request is sent!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                  Text("Your admin request is sent, it will"
                      " approve within 3 working days "
                      "for check you admin status please check here"),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        descriptionController.text = "";
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("OK"),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    });
  }

  Future RegistarationUser() async {
    //var url = Uri.parse("https://aeliya.000webhostapp.com/admins.php");
    var url = Uri.parse("${masterUrl}admins.php");

    Map mapeddate = {
      'id': adminId,
      'name': adminName,
      'email': adminEmail,
      'isAdmin': "no",
    };
    print("JSON DATA : ${mapeddate}");
    http.Response response = await http.post(url, body: mapeddate);

    if (response.statusCode == 200) {
      //store id in shared preferences
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      sharedPreferences.setString('currentUserid', adminId!);

      var data = jsonDecode(response.body);
      print("Data:- $data");
      //for close circular navigator
      Navigator.of(context).pop();
      showWaitngPop(context);
      getUserDetail();
    } else {
      Fluttertoast.showToast(msg: "Some thing went wrong",
          backgroundColor: Color(hexColors("006064")));
      Navigator.of(context).pop();
    }
  }



  //get users details
  Future<GetUserData> getUserDetail() async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    //var url = "https://aeliya.000webhostapp.com/checkUserAdmin.php?id=$getUserId";
    var url = "${masterUrl}checkUserAdmin.php?id=$getUserId";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      //print(data);
      if (data[0]['isAdmin'] != null) {
        if (data[0]['isAdmin'] == "no") {
          print("You are not admin");
        } else {
          print("congrats you are admin now");
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminPannel()));
          SharedPreferences sharedPreferences = await SharedPreferences
              .getInstance();
          sharedPreferences.setBool('isLogin', true);
        }
      }

      print(data[0]['isAdmin']);
      //print(data['isAdmin']);
      return GetUserData.fromJson(data);
    } else {
      return GetUserData.fromJson(data);
    }
  }

  // loginStatus() async {
  //   final SharedPreferences sharedPreferences = await SharedPreferences
  //       .getInstance();
  //   var isLogin = sharedPreferences.getBool('isLogin');
  //
  //   if (isLogin != null) {
  //     if (isLogin == true) {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => AdminPannel()));
  //     } else {
  //       getUserDetail();
  //     }
  //   }
  // }

  isSentRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var check = sharedPreferences.getBool('isSentReq');
    if (check == null) {
      googleLogin();
    }
    else {
      if (check == true) {
        setState(() {
          showButton = true;
        });
        showUnderProcessDailog(context);
      }
    }
  }
}
