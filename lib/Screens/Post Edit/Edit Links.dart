import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/AdminPannel.dart';
import 'package:remove_emoji/remove_emoji.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Hexa color.dart';
import '../../Models/Round Button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../Admin Data/Admin Links.dart';

class EditLinks extends StatefulWidget {
  String elink;
  String ecity;
  String refid;

  EditLinks(this.elink,this.ecity,this.refid, {super.key});

  @override
  State<EditLinks> createState() => _EditLinksState();
}

class _EditLinksState extends State<EditLinks> {

  String? YoutubeLink;
  String? City;
  String? channelName;
  final _formkey = GlobalKey<FormState>();

  TextEditingController YoutubeLinkController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController channelNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    YoutubeLinkController.text = widget.elink;
    CityController.text = widget.ecity;


    YoutubeLink = widget.elink;
    City= widget.ecity;

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Live Program",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            //color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(hexColors('006064')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                //fontStyle: FontStyle.italic,
                                fontSize: 18
                            ),
                            controller: YoutubeLinkController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Paste here Youtube Link",
                              labelText: "Paste here Youtube Link",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onChanged: (value) {
                              print("link  " + value);
                              YoutubeLink = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty || !RegExp(
                                  r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?')
                                  .hasMatch(YoutubeLink!)) {
                                return 'please enter valid link';
                              }
                              return null;
                              //return value!.isEmpty ? 'Please Enter Youtube link' : null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                //fontStyle: FontStyle.italic,
                                fontSize: 18
                            ),
                            controller: CityController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter City",
                              labelText: "Enter City",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onChanged: (value) {
                              City = value.trim();
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please Enter City'
                                  : null;
                            },
                          ),
                          // SizedBox(height: 10,),
                          // TextFormField(
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w700,
                          //       //fontStyle: FontStyle.italic,
                          //       fontSize: 18
                          //   ),
                          //   controller: channelNameController,
                          //   keyboardType: TextInputType.text,
                          //   decoration: InputDecoration(
                          //     hintText: "Channel Name",
                          //     labelText: "Channel Name",
                          //     border: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.white),
                          //         borderRadius: BorderRadius.circular(15)),
                          //   ),
                          //   onChanged: (value) {
                          //     channelName = value;
                          //   },
                          //   validator: (value) {
                          //     return value!.isEmpty
                          //         ? 'Please Enter Channel Name'
                          //         : null;
                          //   },
                          // ),
                          SizedBox(height: 20,),
                          RoundButton(title: "Update",
                              onPress: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if(_formkey.currentState!.validate()){
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: Container(
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                        );
                                      });
                                  UpdateLinks(widget.refid);
                                }

                              })
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),

    )
    );
  }


  Future UpdateLinks(String refid) async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    var getUserName = sharedPreferences.get('getUserName');
    String _DateTimeNow = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());



    //var url = Uri.parse("https://aeliya.000webhostapp.com/updateLinks.php");
    var url = Uri.parse("${masterUrl}updateLinks.php");

    Map mapeddate = {
      'ref_id': refid,
      'userid': getUserId,
      'username': getUserName,
      'link':YoutubeLink,
      'postDateTime':_DateTimeNow,
      'city': City!.removemoji
    };
    print("JSON DATA : ${mapeddate}");
    http.Response response = await http.post(url, body: mapeddate);

    if (response.statusCode == 200) {
      print("Success");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      var data = jsonDecode(response.body);
      print("Data:- $data");
      Fluttertoast.showToast(msg: "Your post is updated",
          backgroundColor: Color(hexColors("006064")));
    /*  sendNotification("Update Live Progeam",
          "${getUserName} ${City}");
*/
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPannel()));

    } else {
      print("failed");
      Fluttertoast.showToast(msg: "Some thing went wrong",
          backgroundColor: Color(hexColors("006064")));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }


  //send message to all user
  void sendNotification(String title, String body) async{
    try{
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "key=AAAAmvSnvys:APA91bFTY1y3nwky9ilhsMcR0EtIZriEK9B6NEX3QkPpTQ2EG_WMYcUzQTbgUnbZ2bq5wR4gomWm0X0Qio-d8eRj2YV6ybPbRqvWfSbAEqVnShdW6dN7qnZSwhRwauW14SxLYBwrb5K9"
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification":<String,dynamic>{
              "title":title,
              "body": body,
              "android_channel_id":"taki"
            },
            //"to":token1,
            "to":"/topics/allNotification",
          },
        ),
      );
    }catch(error){
      print(error);
    }

  }

}