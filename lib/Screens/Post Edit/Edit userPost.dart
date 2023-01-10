import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Models/Hexa color.dart';
import '../../Models/Round Button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditUserPost extends StatefulWidget {
  String e_img;
  String e_progList ;
  String e_stDate ;
  String e_endDate;
  String e_time;
  String e_azakhana ;
  String e_scholar ;
  String e_city ;
  String e_des ;
  String e_notes ;
  String e_refid;

  EditUserPost(this.e_img,this.e_progList,this.e_stDate,
      this.e_endDate,this.e_time,this.e_azakhana,this.e_scholar,
      this.e_city,this.e_des,this.e_notes,
      this.e_refid,
      {super.key});

  @override
  State<EditUserPost> createState() => _EditUserPostState();
}

class _EditUserPostState extends State<EditUserPost> {
  final picker = ImagePicker();

  //get data from user for add post
  String? FullDescription;
  String? AzakhanaName;
  String? SpecialNotes;
  String? ScholarName;
  String? CityName;
  List<String> programList = ['Majlis', 'Mehfil'];
  String _MajlisMehfil = 'Majlis';
  String imageUrlFire = "";
  File? _image;



  final _formkey = GlobalKey<FormState>();

  //getting date in text format
  String StartDate = ""; //"Start Date";
  String EndDate = "";//"End Date";
  String MajlisTime = "";//"Select Time";


  TextEditingController ScholarController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController Nohakhan1Controller = TextEditingController();
  TextEditingController Nohakhan2Controller = TextEditingController();
  TextEditingController AzakhanaNameController = TextEditingController();
  TextEditingController SpecialNotesController = TextEditingController();
  TextEditingController CityNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ScholarController.text = widget.e_scholar;
    descriptionController.text = widget.e_des;
    AzakhanaNameController.text = widget.e_azakhana;
    SpecialNotesController.text = widget.e_notes;
    CityNameController.text = widget.e_city;

    StartDate = widget.e_stDate;
    EndDate = widget.e_endDate;
    MajlisTime = widget.e_time;
    _MajlisMehfil = widget.e_progList;

    //set text
    FullDescription = widget.e_des;
    AzakhanaName = widget.e_azakhana;
    SpecialNotes = widget.e_notes;
    ScholarName = widget.e_scholar;
    CityName = widget.e_city;
    _MajlisMehfil = widget.e_progList;
    StartDate = widget.e_stDate;
    EndDate = widget.e_endDate;
    MajlisTime = widget.e_time;
    _MajlisMehfil = widget.e_progList;

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Post",
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      child: Image.network(widget.e_img)
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
                          fontSize: 18,
                        ),
                        icon: Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                        dropdownColor: Color(hexColors('00BCD4')),
                        value: widget.e_progList,
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
                              widget.e_progList = item!;
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
                              child: InkWell(
                                  onTap: () {
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
                              child: InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(msg:
                                    "Please select date range from start date",
                                        backgroundColor: Color(
                                            hexColors("006064")));
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
                        child: InkWell(
                            onTap: () {
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
                      TextFormField(
                        controller: CityNameController,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            //fontStyle: FontStyle.italic,
                            fontSize: 18),
                        keyboardType: TextInputType.text,
                        //initialValue: widget.e_city,
                        decoration: InputDecoration(
                          labelText: "City Name",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onChanged: (value) {
                          CityName = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter City' : null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                        controller: AzakhanaNameController,
                        keyboardType: TextInputType.text,
                        //initialValue: widget.e_azakhana,
                        decoration: InputDecoration(
                          hintText: "Azakhana Name",
                          labelText: "Azakhana Name",

                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onChanged: (value) {
                          AzakhanaName = value;
                        },
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Enter Azakhana Name'
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          ScholarName = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter Title' : null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: null,
                        cursorColor: Colors.blue,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        //initialValue: widget.e_des,
                        decoration: InputDecoration(
                          hintText: "Description",
                          labelText: "Description",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onChanged: (value) {
                          FullDescription = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter Description' : null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                        controller: SpecialNotesController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "NO Notes (Write NO)",
                          labelText: "Special Notes",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onChanged: (value) {
                          SpecialNotes = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter Special Notes' : null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundButton(
                          title: "Update",
                          onPress: () async {
                            //this code for close keyboard from screen
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (StartDate == "Start date") {
                              Fluttertoast.showToast(msg: "Please Enter Dates",
                                  backgroundColor: Color(hexColors("006064")));
                            } else if (EndDate == "End Date") {
                              Fluttertoast.showToast(msg: "Please Enter Dates",
                                  backgroundColor: Color(hexColors("006064")));
                            }
                            else if (MajlisTime == "Select Time") {
                              Fluttertoast.showToast(msg: "Please Enter Time",
                                  backgroundColor: Color(hexColors("006064")));
                            }
                            else {
                              if (_formkey.currentState!.validate()) {
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
                                UpdatePost(widget.e_refid);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Some thing went wrong",
                                    backgroundColor: Color(
                                        hexColors("006064")));
                              }
                            }
                          })
                    ],
                  ))
            ],
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
      var formattedTime = newTime.format(context);
      setState(() {
        MajlisTime = formattedTime.toString();
      });
    }
  }


  Future UpdatePost(String e_refid) async {

    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    var getUserName = sharedPreferences.get('getUserName');
    String _DateTimeNow = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    print(getUserId);
    print(getUserName);

    var url = Uri.parse("https://aeliya.000webhostapp.com/updatePost.php");

    if(_image == null){


      Map mapeddate = {
        'ref_id': e_refid,
        'postId': getUserId.toString(),
        'azakhana_name': AzakhanaName!,
        'city_name':CityName!,
        'description':FullDescription!,
        'end_date': EndDate!,
        'name_of_schollar': ScholarName!,
        'postDateTime': _DateTimeNow,
        'program_list': _MajlisMehfil!,
        'special_notes': SpecialNotes!,
        'start_date': StartDate!,
        'time': MajlisTime!,
        'user_name': getUserName.toString(),
      };
      print("JSON DATA : ${mapeddate}");
      http.Response response = await http.post(url, body: mapeddate);

      if (response.statusCode == 200) {
        print("Success");

        Fluttertoast.showToast(msg: "Your post is published",
            backgroundColor: Color(
                hexColors("006064")));
        Navigator.pop(context);
        var data = jsonDecode(response.body);
        print("Data:- $data");
        Fluttertoast.showToast(msg: "Your post is published",
            backgroundColor: Color(
                hexColors("006064")));
        Navigator.pop(context);
      } else {
        print("failed");
        Fluttertoast.showToast(msg: "Some thing went wrong",
            backgroundColor: Color(hexColors("006064")));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }

    }else{

      var stream = http.ByteStream(_image!.openRead());
      stream.cast();
      var length = await _image!.length();
      var request = http.MultipartRequest('POST', url);

      request.fields['ref_id'] = e_refid;
      request.fields['postId'] = getUserId.toString();
      request.fields['azakhana_name'] = AzakhanaName!;
      request.fields['city_name'] = CityName!;
      request.fields['description'] = FullDescription!;
      request.fields['end_date'] = EndDate!;
      request.fields['name_of_schollar'] = ScholarName!;
      request.fields['postDateTime'] = _DateTimeNow!;
      request.fields['program_list'] = _MajlisMehfil!;
      request.fields['special_notes'] = SpecialNotes!;
      request.fields['start_date'] = StartDate!;
      request.fields['time'] = MajlisTime!;
      request.fields['user_name'] = getUserName.toString();

      var _multipart = http.MultipartFile(
        'image',
        stream,
        length,
        filename: _image!.path.toString(),
      );
      request.files.add(_multipart);


      var response = await request.send();

      if(response.statusCode == 200){
        Navigator.pop(context);
        print(response.stream.transform(utf8.decoder).listen((event) {
          print(event);
        }));
        // sendNotification("${_MajlisMehfil}: ${ScholarName}",
        //     "${AzakhanaName} ${StartDate} to ${EndDate} ${MajlisTime}");
        Fluttertoast.showToast(msg: "Your post is published",
            backgroundColor: Color(
                hexColors("006064")));
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        print("NOT suuccess");
      }
    }

  }
}


