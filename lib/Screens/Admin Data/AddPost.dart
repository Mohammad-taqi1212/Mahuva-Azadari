import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Models/Hexa color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Models/Round Button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:remove_emoji/remove_emoji.dart';



class AddPost extends StatefulWidget {
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final picker = ImagePicker();


  //get data from user for add post
  String? FullDescription;
  String? Nauhkhan1;
  String? Nauhkhan2;
  String? AzakhanaName;
  String? SpecialNotes;
  String? ScholarName;
  String? CityName;
  List<String> programList = ['Select event','Majlis', 'Mehfil','Event'];
  String _MajlisMehfil = "Select event";
  String imageUrlFire = "";
  File? _image;



  final _formkey = GlobalKey<FormState>();
  bool showSpinner = false;

  //getting date in text format
  String StartDate = "Start Date";
  String EndDate = "End Date";
  String MajlisTime = "Select Time";
  final dateController = TextEditingController();

  TextEditingController ScholarController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController Nohakhan1Controller = TextEditingController();
  TextEditingController Nohakhan2Controller = TextEditingController();
  TextEditingController AzakhanaNameController = TextEditingController();
  TextEditingController SpecialNotesController = TextEditingController();
  TextEditingController CityNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Post",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic),
          ),
          centerTitle: true,
          backgroundColor: Color(hexColors('006064')),
        ),
        //backgroundColor: Color(hexColors('9A7B4F')),
        body:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                      child: _image != null
                          ? ClipRRect(
                        child: Image.file(
                          _image!.absolute,
                          width: double.infinity,
                          height: 250,
                          //fit: BoxFit.fitHeight,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Color(hexColors("80DEEA")),
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        height: 150,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      "Select Program",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          //fontStyle: FontStyle.italic,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Color(hexColors('00BCD4')),
                        ),
                        height: 50,
                        width: 120,
                        child: DropdownButton<String>(
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            //fontStyle: FontStyle.italic,
                            fontSize: 15,
                          ),
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          dropdownColor: Color(hexColors('00796B')),
                          value: _MajlisMehfil,
                          isExpanded: true,
                          //alignment: Alignment.center,
                          items: programList
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                alignment: Alignment.center,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ))
                              .toList(),
                          onChanged: (item) =>
                              setState(() {
                                _MajlisMehfil = item!;
                              }),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: Color(hexColors('00BCD4')),
                                ),
                                height: 50,
                                width: 120,
                                child: Center(
                                  child: InkWell(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        pickDate(context);
                                      },
                                      child: Text(
                                        StartDate,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            //fontFamily: 'Amiri',
                                            fontWeight: FontWeight.w700,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 18),
                                      )),
                                ),
                              ),
                            ),
                            Text("TO",
                                style: TextStyle(
                                  //color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    //fontStyle: FontStyle.italic,
                                    fontSize: 18)),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: Color(hexColors('00BCD4')),
                                ),
                                height: 50,
                                width: 120,
                                child: Center(
                                  child: InkWell(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        // Fluttertoast.showToast(msg:
                                        // "Please select date range from start date",
                                        //     backgroundColor: Color(
                                        //         hexColors("006064")));
                                        pickDate(context);
                                      },
                                      child: Text(
                                        EndDate,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 18),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Color(hexColors('00BCD4')),
                          ),
                          height: 50,
                          width: 120,
                          child: Center(
                            child: InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  pickTime(context);
                                },
                                child: Text(
                                  MajlisTime,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                  ),
                                )),
                          ),
                        ),
                        TextFormField(
                          maxLength: 15,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              //fontStyle: FontStyle.italic,
                              fontSize: 18),
                          controller: CityNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "City Name",
                            //hintStyle: TextStyle(color: Colors.black),
                            labelText: "City Name",
                            //errorStyle: TextStyle(color: Colors.white),
                            //labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            CityName = value.trim();
                          },
                          validator: (value) {
                            return value!.trim().isEmpty ? 'Enter City' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLength: 40,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: AzakhanaNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Azakhana Name",
                            labelText: "Azakhana Name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            AzakhanaName = value.trim();
                          },
                          validator: (value) {
                            return value!.trim().isEmpty
                                ? 'Enter Azakhana Name'
                                : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLength: 40,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: ScholarController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Name of Scholar",
                            labelText: "Name of Scholar",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            ScholarName = value.trim();
                          },
                          validator: (value) {
                            return value!.trim().isEmpty ? 'Enter Title' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: null,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: Colors.blue,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Description",
                            labelText: "Description",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            FullDescription = value.trim();
                          },
                          validator: (value) {
                            return value!.trim().isEmpty ? 'Enter Description' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: SpecialNotesController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Special Notes",
                            labelText: "Special Notes",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            SpecialNotes = value.trim();
                          },
                          validator: (value) {
                            return value!.trim().isEmpty ? 'Enter Special Notes' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RoundButton(
                            title: "Upload Post",
                            onPress: () async {
                              //this code for close keyboard from screen
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                showSpinner = true;
                              });

                              if (StartDate == "Start date") {
                                Fluttertoast.showToast(msg: "Please Enter Dates",
                                    backgroundColor: Color(hexColors("006064")));
                                setState(() {
                                  showSpinner = false;
                                });
                              } else if (EndDate == "End Date") {
                                Fluttertoast.showToast(msg: "Please Enter Dates",
                                    backgroundColor: Color(hexColors("006064")));
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                              else if (MajlisTime == "Select Time") {
                                Fluttertoast.showToast(msg: "Please Enter Time",
                                    backgroundColor: Color(hexColors("006064")));
                                setState(() {
                                  showSpinner = false;
                                });
                              } else if (_image == null) {
                                Fluttertoast.showToast(
                                    msg: "Please Select Scholar Image",
                                    backgroundColor: Color(hexColors("006064")));
                                setState(() {
                                  showSpinner = false;
                                });
                              }else if (_MajlisMehfil == "Select event"){
                                Fluttertoast.showToast(
                                    msg: "Please Select Event (Majlis,Mehfil,Event)",
                                    backgroundColor: Color(hexColors("006064")));
                              }
                              else {
                                if (_formkey.currentState!.validate()) {
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
                                  AddPostApi();
                                }
                              }
                            })
                      ],
                    ))
              ],
            ),
          ),
        ),

      ),
    );
  }

  //Function for get image from gallery
  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("image path $_image");
        print("Actual image size ${_image!.lengthSync()/1024}");

      } else {
        print("No image selected");
      }
    });
  }

  //Function for get image from camera
  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  //Function for show alertbox to user for image picker
  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getGalleryImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text("Gallery"),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //Method for pickup the date
  void pickDate(BuildContext context) async {
    final initialDateRange =
    DateTimeRange(start: DateTime.now(), end: DateTime.now());
    final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime
            .now()
            .month - 1),
        lastDate: DateTime(DateTime
            .now()
            .year + 2));

    if (newDateRange != null) {
      //for checking date is less then 10 days
      var crdt = DateTime.now();
      var _diff = crdt
          .difference(newDateRange.start as DateTime)
          .inDays;
      print("here is deifferent${_diff}");

      if (_diff > 10) {
        Fluttertoast.showToast(msg: "You can select past 10 days only",
            backgroundColor: Color(hexColors("006064")));
        setState(() {
          StartDate = "Start Date";
          EndDate = "End Date";
        });
      } else {
        String formattedDateStart =
        DateFormat('dd-MM-yyyy').format(newDateRange.start);
        String formattedDateEnd =
        DateFormat('dd-MM-yyyy').format(newDateRange.end);
        setState(() {
          StartDate = formattedDateStart;
          EndDate = formattedDateEnd;
        });
      }
    }
  }

  //Method for pickup the time
  void pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime =
    await showTimePicker(context: context, initialTime: initialTime);
    if (newTime != null) {
      // this variable for set time format
      // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      // print(formattedTime); //output 14:59:00
      var formattedTime = newTime.format(context);
      // DateTime parsedTime = DateFormat.jm().parse(newTime.format(context).toString());
      // //converting to DateTime so that we can further format on different pattern.
      // print(parsedTime); //output 1970-01-01 22:53:00.000
      setState(() {
        MajlisTime = formattedTime.toString();
      });
    }
  }


  Future AddPostApi() async {

    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    var getUserName = sharedPreferences.get('getUserName');
    String _DateTimeNow = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    print(getUserId);
    print(getUserName);

    //for compress image
    var imageMB;

    if(_image!.lengthSync()/1024 > 600){
      File compressedFile = await FlutterNativeImage.compressImage(_image!.path,
          quality: 100, percentage: 20);
      imageMB = compressedFile;
      print("compressed image size ${compressedFile.lengthSync()/1024}");
    }else{
      imageMB = _image;
      print("server image ${imageMB!.lengthSync()/1024}");
    }

    var stream = http.ByteStream(imageMB!.openRead());
    stream.cast();
    var length = await imageMB!.length();
    //var url = Uri.parse("https://aeliya.000webhostapp.com/addPost.php");
    var url = Uri.parse("${masterUrl}addPost.php");
    var request = http.MultipartRequest('POST', url);

    request.fields['postId'] = getUserId.toString();
    request.fields['azakhana_name'] = AzakhanaName!.removemoji;
    request.fields['city_name'] = CityName!.removemoji;
    request.fields['description'] = FullDescription!.removemoji;
    request.fields['end_date'] = EndDate!;
    request.fields['name_of_schollar'] = ScholarName!.removemoji;
    request.fields['postDateTime'] = _DateTimeNow!;
    request.fields['program_list'] = _MajlisMehfil!;
    request.fields['special_notes'] = SpecialNotes!.removemoji;
    request.fields['start_date'] = StartDate!;
    request.fields['time'] = MajlisTime!;
    request.fields['user_name'] = getUserName.toString();

    var _multipart = http.MultipartFile(
      'image',
      stream,
      length,
      filename: imageMB!.path.toString(),
    );
    request.files.add(_multipart);


    var response = await request.send();

    if(response.statusCode == 200){
      Navigator.pop(context);
      print(response.stream.transform(utf8.decoder).listen((event) {
        print(event);
        // final SharedPreferences sharepreference = await SharedPreferences.getInstance();
        // var token1 = sharepreference.getString('userToken');
        // await Future.delayed(Duration(seconds: 10));
      }));
     /* sendNotification("${_MajlisMehfil}: ${ScholarName}",
          "${AzakhanaName} ${StartDate} to ${EndDate} ${MajlisTime}");*/
      Fluttertoast.showToast(msg: "Your post is published",
          backgroundColor: Color(
              hexColors("006064")));
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
      print("NOT suuccess");
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

/*
toasted property
Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
 */