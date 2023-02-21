import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/Admin%20Links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Hexa color.dart';
import '../../Models/Round Button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddLiveProgram extends StatefulWidget {
  const AddLiveProgram({Key? key}) : super(key: key);

  @override
  State<AddLiveProgram> createState() => _AddLiveProgramState();
}

class _AddLiveProgramState extends State<AddLiveProgram> {

  String? YoutubeLink;
  String? City;
  String? channelName;
  final _formkey = GlobalKey<FormState>();

  TextEditingController YoutubeLinkController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController channelNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Live Program",
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
                              if (value!.trim().isEmpty || !RegExp(
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
                              City = value;
                            },
                            validator: (value) {
                              return value!.trim().isEmpty
                                  ? 'Please Enter City'
                                  : null;
                            },
                          ),
                          SizedBox(height: 20,),
                          RoundButton(title: "Upload Post",
                              onPress: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if(_formkey.currentState!.validate()){
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Container(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      });
                                  AddLiveProgram();
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


  Future AddLiveProgram() async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    var getUserName = sharedPreferences.get('getUserName');
    String _DateTimeNow = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());



    var url = Uri.parse("https://aeliya.000webhostapp.com/addLinks.php");

    Map mapeddate = {
      'userid': getUserId,
      'username': getUserName,
      'link':YoutubeLink,
      'postDateTime':_DateTimeNow,
      'city': City
    };
    print("JSON DATA : ${mapeddate}");
    http.Response response = await http.post(url, body: mapeddate);

    if (response.statusCode == 200) {
      print("Success");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      var data = jsonDecode(response.body);
      print("Data:- $data");
      Navigator.pop(context);

      sendNotification("Live Program Added",
          "${getUserName} ${City}");

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
          'Authorization': "key=AAAAXFH7l3I:APA91bFNjc9LvV2YtlXUHlcUBa-OL_YdHOGl6zuTUe2REtScRnzTEO5yUU5BqAknmtul3Jqkdl0LLeh3a3QHeYe_vqYTeqYpWXqHr8A9TP63efERorEmnBj9vZ8hQxN2I8u6NCiPkKh3"
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