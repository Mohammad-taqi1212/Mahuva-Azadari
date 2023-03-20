import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/AddMayyatNews.dart';
import 'package:remove_emoji/remove_emoji.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Hexa color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import '../../Models/Round Button.dart';
import 'package:http/http.dart' as http;

import '../Admin Data/Admin M_News.dart';
import '../Admin Data/AdminPannel.dart';

class EditMnews extends StatefulWidget {

  String e_img;
  String e_Mname ;
  String e_city ;
  String e_date;
  String e_Mtime;
  String e_Ntime ;
  String e_address ;
  String e_refid ;


  EditMnews(this.e_img,this.e_Mname,this.e_city,
      this.e_date,this.e_Mtime,this.e_Ntime,this.e_address,
      this.e_refid,
      {super.key});

  //const EditMnews({Key? key}) : super(key: key);

  @override
  State<EditMnews> createState() => _EditMnewsState();
}

class _EditMnewsState extends State<EditMnews> {

  File? _image;
  final picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  TextEditingController MnameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController AddressController = TextEditingController();

  String? Mname;
  String? city;
  String? address;
  String _date = "Date";
  String _Mtime = "Mayyat Time";
  String _Ntime = "Namaz Time";

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    MnameController.text = widget.e_Mname;
    cityController.text = widget.e_city;
    AddressController.text = widget.e_address;
    _date = widget.e_date;

    Mname = widget.e_Mname;
    city = widget.e_city;;
    address = widget.e_address;

    if(widget.e_Mtime == "Will update"){
      _Mtime = "Mayyat Time";
    }
    else{
      _Mtime = widget.e_Mtime;
    }
    if(widget.e_Ntime == "Will update"){
      _Ntime = "Namaz Time";
    }else{
      _Ntime = widget.e_Ntime;
    }



  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar:
      AppBar(title: Text("Edit Mayyat News",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),),
        centerTitle: true,
        backgroundColor: Color(hexColors('006064')),
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
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
                            : chekImage(widget.e_img)
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: MnameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Name of Marhum",
                            labelText: "Name of Marhum",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            Mname = value.trim();
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'Please Enter MarhumName' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          maxLength: 15,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: cityController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "City Name",
                            labelText: "City Name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            city = value.trim();
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Enter City Name'
                                : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          maxLines: null,
                          cursorColor: Colors.blue,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          controller: AddressController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Address and other derails",
                            labelText: "Address",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            address = value.trim();
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'Enter Description' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      pickDate(context);
                                    },
                                    child: Text(
                                      _date,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    )),
                              ),
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
                                child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      pickMTime(context);
                                    },
                                    child: Text(
                                      _Mtime,
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
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
                                FocusManager.instance.primaryFocus?.unfocus();
                                pickNTime(context);
                              },
                              child: Text(
                                _Ntime,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                              )),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Text("Note:- If woman please do not post image."
                            " You can add post without mayyat and namaze mayyat time"
                            " once it will decide you can update this post from admin pannel",
                          style: TextStyle(color: Colors.purple),),
                        SizedBox(height: 10,),
                        RoundButton(
                            title: "Update",
                            onPress: () async {
                              //this code for close keyboard from screen
                              FocusManager.instance.primaryFocus?.unfocus();

                              if(_date == "Date"){
                                Fluttertoast.showToast(msg: "Please select Date",
                                    backgroundColor: Color(
                                        hexColors("006064")));
                              }else{
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

                                  UpdateMayyatNews(widget.e_refid);
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

  //Method for pickup the date
  void pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime
            .now()
            .year + 1)
    );

    if (newDate != null) {
      String formattedDate =
      DateFormat('dd-MM-yyyy').format(newDate!);
      setState(() {
        _date = formattedDate;
      });
    }
  }

  //Method for pickup the time
  void pickMTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime =
    await showTimePicker(context: context, initialTime: initialTime);
    if (newTime != null) {
      var formattedTime = newTime.format(context);
      setState(() {
        _Mtime = formattedTime.toString();
      });
    }
  }
  //Method for pickup the time
  void pickNTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime =
    await showTimePicker(context: context, initialTime: initialTime);
    if (newTime != null) {
      var formattedTime = newTime.format(context);
      setState(() {
        _Ntime = formattedTime.toString();
      });
    }
  }

  Future UpdateMayyatNews(String e_refid) async {

    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    var getUserName = sharedPreferences.get('getUserName');
    String _DateTimeNow = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());

    if(_Mtime == "Mayyat Time"){
      _Mtime = "Will update";
    }
    if(_Ntime == "Namaz Time"){
      _Ntime = "Will update";
    }


    if(_image == null){

      var url = Uri.parse("${masterUrl}updateMayyatNews.php");

      Map mapeddate = {
        'ref_id':e_refid,
        'id': getUserId,
        'name': Mname!.removemoji,
        'city':city!.removemoji,
        'date':_date,
        'mayyatTime': _Mtime,
        'namazTime': _Ntime,
        'Address': address!.removemoji,
        'postTime': _DateTimeNow,
        'username': getUserName.toString(),
      };
      print("JSON DATA : ${mapeddate}");
      http.Response response = await http.post(url, body: mapeddate);


      if (response.statusCode == 200) {
        print("Success");
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Your post is Updated",
            backgroundColor: Color(
                hexColors("006064")));
        /*sendNotification(" :إِنَّا لِلَّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ (Update Mayyat News)${Mname}",
            "City : ${city}, Mayyat Time : ${_Mtime}");*/
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPannel()));
        var data = jsonDecode(response.body);
        print("Data:- $data");
      } else {
        print("failed");
        Fluttertoast.showToast(msg: "Some thing went wrong",
            backgroundColor: Color(hexColors("006064")));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }

    }
    else{

      var stream = http.ByteStream(_image!.openRead());
      stream.cast();
      var length = await _image!.length();
      var url = Uri.parse("${masterUrl}updateMayyatNews.php");
      var request = http.MultipartRequest('POST', url);


      request.fields['ref_id'] = e_refid;
      request.fields['id'] = getUserId.toString();
      request.fields['name'] = Mname!.removemoji;
      request.fields['city'] = city!.removemoji;
      request.fields['date'] = _date;
      request.fields['mayyatTime'] = _Mtime;
      request.fields['namazTime'] = _Ntime;
      request.fields['Address'] = address!.removemoji;
      request.fields['postTime'] = _DateTimeNow;
      request.fields['username'] = getUserName.toString();

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
        // sendNotification(" :إِنَّا لِلَّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ ${Mname}",
        //     "City : ${city}, Mayyat Time : ${_Mtime}");
        Fluttertoast.showToast(msg: "Your post is Update",
            backgroundColor: Color(
                hexColors("006064")));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPannel()));
      }else{
        Navigator.pop(context);
        print("NOT suuccess");
      }
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

  chekImage(String imagepath) {
    if(imagepath.isEmpty){
      print("null");
      return
        Container(
          decoration: BoxDecoration(
              color: Color(hexColors("80DEEA")),
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          height: 150,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        );
    }else{
      print("not null");
      return
        Container(
            width: double.infinity,
            height: 150,
            child: Image.network("${masterUrl}"+imagepath)
        );
    }

  }


}


