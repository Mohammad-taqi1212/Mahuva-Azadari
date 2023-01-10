import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Models/Hexa%20color.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:intl/intl.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/AddPost.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/getAdminPost.dart';
import '../Drawer/Home.dart';
import '../Post Edit/Edit userPost.dart';

class AdminPost extends StatefulWidget {
  @override
  State<AdminPost> createState() => _AdminPostState();
}

class _AdminPostState extends State<AdminPost> {

  late Stream<GetAdminPost> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await getCurrentAdminPost());

  String searchText = "";
  TextEditingController searchController = TextEditingController();
  bool isVisible = false;
  String ComparisonText = "";
  Color? ContainerColor;
  bool showSearchBar = false;
  bool showFlaotingButton = true;


  Future<GetAdminPost> getCurrentAdminPost() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    print(getUserId);
    var url = "https://aeliya.000webhostapp.com/AdminPost.php?id=$getUserId";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      //print(jsondata);
      //print(jsondata['data'.length]);
      return GetAdminPost.fromJson(jsondata);
    } else {
      return GetAdminPost.fromJson(jsondata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          //tap any where to close keyboard
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          //backgroundColor: Color(hexColors("8E24AA")),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Visibility(
                    visible: showSearchBar,
                    child: AnimSearchBar(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      helpText: "Search Azakhana Name",
                      textController: searchController
                        ..addListener(() {
                          setState(() {
                            searchText = searchController.text;
                          });
                        }),
                      closeSearchOnSuffixTap: true,
                      rtl: true,
                      onSuffixTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        searchController.clear();
                        setState(() {
                          showSearchBar = false;
                          showFlaotingButton = true;
                        });
                      },
                    ),
                  ),
                  //child: Container()
                ),
                Expanded(
                    child: StreamBuilder<GetAdminPost>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(

                          //close keyboard while scroll
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, i) {
                            var postList = snapshot.data!.data![i];
                            String tempSearch =
                                postList.azakhanaName.toString();

                            // //for date comparison
                            DateTime stdt = DateFormat('dd-MM-yyyy')
                                .parse(postList.startDate.toString());
                            DateTime endt = DateFormat('dd-MM-yyyy')
                                .parse(postList.endDate.toString());
                            DateTime crdt = DateTime.now();

                            final DateTime now = DateTime.now();
                            final DateFormat formatter =
                                DateFormat('dd-MM-yyyy');
                            final String formatted = formatter.format(now);
                            final crdt1 = DateTime.tryParse(formatted);

                            if (stdt.isBefore(crdt)) {
                              //past
                              if (endt.isBefore(crdt)) {
                                ComparisonText = "Past";
                                ContainerColor = Colors.red;
                              } else if (endt.isAtSameMomentAs(crdt)) {
                                ComparisonText = "Ongoing";
                                ContainerColor = Colors.green;
                              } else {
                                ComparisonText = "Ongoing";
                                ContainerColor = Colors.green;
                              }
                            } else if (stdt.isAfter(crdt)) {
                              //upcoming
                              ComparisonText = "Upcoming";
                              ContainerColor = Colors.blue;
                            } else {
                              //ongoing
                              ComparisonText = "Ongoing";
                              ContainerColor = Colors.green;
                            }

                            if (searchController.text.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Card(
                                  color: Color(hexColors("00BCD4")),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                          leading: FullScreenWidget(
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(color: Colors.black),
                                                  color: Color(hexColors("84FFFF")),
                                                ),
                                                child: Image.network("https://aeliya.000webhostapp.com/"+postList.imagePath.toString()),
                                              )),
                                          title: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Scholar: ",
                                                    Hdetail: postList.nameOfSchollar.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Program: ",
                                                    Hdetail: postList.programList.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Date: ",
                                                      Hdetail: "${postList.startDate} TO  ${postList.endDate}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Time: ",
                                                    Hdetail: postList.time.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Azakhana: ",
                                                    Hdetail: postList.azakhanaName.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "City: ",
                                                    Hdetail: postList.cityName.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        shape: BoxShape.circle),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          print("edit tap");
                                                          var img = "https://aeliya.000webhostapp.com/${postList.imagePath!}";
                                                          var progList = postList.programList;
                                                          var stDate = postList.startDate;
                                                          var endDate = postList.endDate;
                                                          var time = postList.time;
                                                          var azakhana = postList.azakhanaName;
                                                          var scholar = postList.nameOfSchollar;
                                                          var city = postList.cityName;
                                                          var des = postList.description;
                                                          var notes = postList.specialNotes;
                                                          var refid = postList.refId;
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditUserPost(
                                                            img,progList!,stDate!,endDate!,time!,azakhana!,scholar!,city!,des!,notes!,refid!
                                                          )));
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.yellow,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        shape: BoxShape.circle),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          print("delete tap");
                                                          _showDeleteDialog(postList.refId);
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                      ExpansionTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5.0),
                                              padding: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  color: ContainerColor),
                                              child: Text(
                                                ComparisonText,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  //backgroundColor: Colors.red
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Description:",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                        iconColor: Colors.white,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Text(
                                              postList.description.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Text(
                                            "Special Notes:",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Text(
                                              postList.specialNotes.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  postList.userName.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                    postList.postDateTime
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              //for share post to other app
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    5.0),
                                                child: IconButton(
                                                  icon: Icon(Icons.share,color: Colors.white,),
                                                  onPressed: () async{

                                                    //for image
                                                    final urlImage = "http://aeliya.000webhostapp.com/${postList.imagePath}";
                                                    final url = Uri.parse(urlImage);
                                                    final response = await http.get(url);
                                                    final bytes = response.bodyBytes;

                                                    //for temporary store image in device
                                                    final temp = await getTemporaryDirectory();
                                                    final path = '${temp.path}/image.jpg';
                                                    File(path).writeAsBytesSync(bytes);

                                                    await Share.shareXFiles([XFile(path)],
                                                        subject: "Azadari Schedule app",
                                                        text:

                                                        "⬛ Azadari Schedule App ⬛ \n"
                                                            "🔊 ${postList.cityName} \n \n \n"
                                                            "▪️Scholar:- ${postList.nameOfSchollar} \n"
                                                            "▪️Program:- ${postList.programList} \n"
                                                            "▪️Date:- ${postList.startDate} TO  ${postList.endDate} \n"
                                                            "▪️Time:- ${postList.time}\n"
                                                            "▪️City:- ${postList.cityName} \n"
                                                            "▪️Description:- ${postList.description} \n"
                                                            "▪️Special Notes:- ${postList.specialNotes} \n \n \n"
                                                            "✅ For daily majlis update please download our app from play store"
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (tempSearch
                                .toLowerCase()
                                .contains(searchController.text.toString())) {
                              return Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Card(
                                  color: Color(hexColors("00BCD4")),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                          leading: FullScreenWidget(
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(color: Colors.black),
                                                  color: Color(hexColors("84FFFF")),
                                                ),
                                                child: Image.network("https://aeliya.000webhostapp.com/"+postList.imagePath.toString()),
                                              )),
                                          title: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Scholar: ",
                                                    Hdetail: postList.nameOfSchollar.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Program: ",
                                                    Hdetail: postList.programList.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Date: ",
                                                      Hdetail: "${postList.startDate} TO  ${postList.endDate}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Time: ",
                                                    Hdetail: postList.time.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "Azakhana: ",
                                                    Hdetail: postList.azakhanaName.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  titleStyle(Htitle: "City: ",
                                                    Hdetail: postList.cityName.toString(),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                            Colors.white),
                                                        shape: BoxShape.circle),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          print("edit tap");
                                                          var img = "https://aeliya.000webhostapp.com/${postList.imagePath!}";
                                                          var progList = postList.programList;
                                                          var stDate = postList.startDate;
                                                          var endDate = postList.endDate;
                                                          var time = postList.time;
                                                          var azakhana = postList.azakhanaName;
                                                          var scholar = postList.nameOfSchollar;
                                                          var city = postList.cityName;
                                                          var des = postList.description;
                                                          var notes = postList.specialNotes;
                                                          var refid = postList.refId;
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditUserPost(
                                                              img,progList!,stDate!,endDate!,time!,azakhana!,scholar!,city!,des!,notes!,refid!
                                                          )));
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.yellow,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                            Colors.white),
                                                        shape: BoxShape.circle),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          print("delete tap");
                                                          _showDeleteDialog(postList.refId);//(context);
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                      ExpansionTile(
                                        title: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5.0),
                                              padding: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  color: ContainerColor),
                                              child: Text(
                                                ComparisonText,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  //backgroundColor: Colors.red
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Description:",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  decoration:
                                                  TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                        iconColor: Colors.white,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Text(
                                              postList.description.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Text(
                                            "Special Notes:",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                TextDecoration.underline),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Text(
                                              postList.specialNotes.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Text(
                                                  postList.userName.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Text(
                                                    postList.postDateTime
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              //for share post to other app
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    5.0),
                                                child: IconButton(
                                                  icon: Icon(Icons.share,color: Colors.white,),
                                                  onPressed: () async{

                                                    //for image
                                                    final urlImage = "http://aeliya.000webhostapp.com/${postList.imagePath}";
                                                    final url = Uri.parse(urlImage);
                                                    final response = await http.get(url);
                                                    final bytes = response.bodyBytes;

                                                    //for temporary store image in device
                                                    final temp = await getTemporaryDirectory();
                                                    final path = '${temp.path}/image.jpg';
                                                    File(path).writeAsBytesSync(bytes);

                                                    await Share.shareXFiles([XFile(path)],
                                                        subject: "Azadari Schedule app",
                                                        text:

                                                        "⬛ Azadari Schedule App ⬛ \n"
                                                            "🔊 ${postList.cityName} \n \n \n"
                                                            "▪️Scholar:- ${postList.nameOfSchollar} \n"
                                                            "▪️Program:- ${postList.programList} \n"
                                                            "▪️Date:- ${postList.startDate} TO  ${postList.endDate} \n"
                                                            "▪️Time:- ${postList.time}\n"
                                                            "▪️City:- ${postList.cityName} \n"
                                                            "▪️Description:- ${postList.description} \n"
                                                            "▪️Special Notes:- ${postList.specialNotes} \n \n \n"
                                                            "✅ For daily majlis update please download our app from play store"
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if (snapshot.hasError) {
                      return Center(
                        child: Text("No Data !"),
                      );
                    }
                    else {
                      return Center(
                        child: Text("No Data"),
                      );
                    }
                  },
                ))
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: showFlaotingButton,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: FloatingActionButton(
                backgroundColor: Colors.grey.shade300,
                elevation: 5,
                foregroundColor: Colors.black,
                mini: true,
                shape: CircleBorder(),
                tooltip: "tap to search",
                onPressed: () {
                  setState(() {
                    showSearchBar = true;
                    showFlaotingButton = false;
                  });
                },
                child: Icon(Icons.search),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        ),
      ),
    );
  }

  // Future<bool> deleteConfirm(context) async {
  //   return await showDialog(context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //     return AlertDialog(
  //         title: Text("Are you sure you want to delete this permanently"),
  //         content: Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             TextButton(
  //               onPressed: () {
  //                 print("Deleted");
  //               },
  //               child: Text("Yes",
  //               style: TextStyle(color: Colors.red,
  //               fontSize: 15),),
  //             ),
  //             //SizedBox(width: 10,),
  //             TextButton(
  //               onPressed: () {
  //                 print("Deleted");
  //               },
  //               child: Text("No", style: TextStyle(
  //                 fontSize:15
  //               ),),
  //             ),
  //
  //           ],
  //         )
  //     );
  //   });
  // }

  Future<void> _showDeleteDialog(String? refId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',
              style: TextStyle(color: Colors.red,
              fontSize: 15),),
              onPressed: () {
                Navigator.of(context).pop();
                print('Confirmed');
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
                deletePost(refId);
              },
            ),
            TextButton(
              child: Text('No',
              style: TextStyle(
                fontSize: 15
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> deletePost(String? refId) async {
    var url = "https://aeliya.000webhostapp.com/deletePost.php?refId=$refId";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      print("deleted");
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Deleted successfully",
          backgroundColor: Color(hexColors("006064")));
    } else {
      Fluttertoast.showToast(msg: "something went wrong",
          backgroundColor: Color(hexColors("006064")));
    }
  }

}
