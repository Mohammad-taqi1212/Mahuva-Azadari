import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Models/AdminPostModel.dart';
import 'package:mahuva_azadari/Models/Hexa%20color.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Drawer/Home.dart';
import '../Post Edit/Edit userPost.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdminPost extends StatefulWidget {
  @override
  State<AdminPost> createState() => _AdminPostState();
}

class _AdminPostState extends State<AdminPost> {

  late Stream<AdminPostModel> stream = Stream.periodic(Duration(seconds: 3))
      .asyncMap((event) async => await getCurrentAdminPost());

  String searchText = "";
  TextEditingController searchController = TextEditingController();
  bool isVisible = false;
  String ComparisonText = "";
  Color? ContainerColor;
  bool showSearchBar = false;
  bool showFlaotingButton = true;
  var currentPage = 1;


  AdminPostModel dummyData = AdminPostModel();
  bool isRefersh = false;
  final RefreshController refreshController = RefreshController();

  Future<AdminPostModel> getCurrentAdminPost() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');
    print(getUserId);
    //var url = "https://aeliya.000webhostapp.com/AdminPost.php?id=$getUserId&pageNo=$currentPage";
    var url = "${masterUrl}AdminPost.php?id=$getUserId&pageNo=$currentPage";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = AdminPostModel.fromJson(jsondata);

    var newData = [...?dummyData.data, ...?_apiData.data];

    if (response.statusCode == 200) {

      if(isRefersh == true){
        setState((){
          isRefersh = false;
          searchController.text ="";
        });
        refreshController.refreshCompleted();
      }
      else{
        if(currentPage == _apiData.pages){
          refreshController.loadNoData();
        }else{
          refreshController.loadComplete();
        }
      }
      final refids = newData.map((e) => e.refId).toSet();
      newData.retainWhere((ids) => refids.remove(ids.refId));
      //dummyData.data = newData.toSet().toList();
      dummyData.data = newData;

      return dummyData;

    } else {
      return AdminPostModel.fromJson(jsondata);
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
          backgroundColor: Colors.white,
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
                            searchText = searchController.text.trim();
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
                    child: StreamBuilder<AdminPostModel>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SmartRefresher(
                        controller: refreshController,
                        enablePullUp: true,
                        child: ListView.builder(

                            //close keyboard while scroll
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, i) {
                              var postList = snapshot.data!.data![i];
                              String tempSearch =
                                  postList.azakhanaName.toString();

                              if(postList.status == "Ongoing"){
                                ContainerColor = Colors.green;
                              }else if(postList.status == "Upcoming"){
                                ContainerColor = Colors.blue;
                              }else{
                                ContainerColor = Colors.red;
                              }

                              if (searchController.text.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5, top:10),
                                  child: Material(
                                    elevation: 6,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                        gradient: LinearGradient(
                                            colors: [
                                              Color(hexColors("00BCD4")),
                                              Colors.green,
                                              //Color(hexColors("4CAF50")),
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight
                                        ),
                                      ),
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
                                                    child: Image.network("${masterUrl}"+postList.imagePath.toString()),
                                                  )),
                                              title: Column(
                                                children: [
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
                                                      titleStyle(Htitle: "Scholar/Event: ",
                                                        Hdetail: postList.nameOfSchollar.toString(),),
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
                                                              var img = "${masterUrl}${postList.imagePath!}";
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
                                                              _showDeleteDialog(postList.refId,postList.imagePath);
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
                                                  width: 100,
                                                  margin: EdgeInsets.all(5.0),
                                                  padding: EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      color: ContainerColor),
                                                  child: Center(
                                                    child: Text(
                                                      postList.status!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                        //backgroundColor: Colors.red
                                                      ),
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
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(5.0),
                                                      child: Text(
                                                        postList.userName.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
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
                                                        final urlImage = "${masterUrl}${postList.imagePath}";
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
                                                                "Download link https://play.google.com/store/apps/details?id=com.aleyia_azadari_schedule \n"
                                                                "🔊 ${postList.cityName} \n \n \n"
                                                                "▪️Scholar/Event:- ${postList.nameOfSchollar} \n"
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
                                  ),
                                );
                              } else if (tempSearch
                                  .toLowerCase()
                                  .contains(searchController.text.toString().trim())) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5, top:10),
                                  child: Material(
                                    elevation: 6,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                        gradient: LinearGradient(
                                            colors: [
                                              Color(hexColors("00BCD4")),
                                              Colors.green,
                                              //Color(hexColors("4CAF50")),
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight
                                        ),
                                      ),
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
                                                    child: Image.network("${masterUrl}"+postList.imagePath.toString()),
                                                  )),
                                              title: Column(
                                                children: [
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
                                                      titleStyle(Htitle: "Scholar/Event: ",
                                                        Hdetail: postList.nameOfSchollar.toString(),),
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
                                                              var img = "${masterUrl}${postList.imagePath!}";
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
                                                              _showDeleteDialog(postList.refId,postList.imagePath);
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
                                                  width: 100,
                                                  margin: EdgeInsets.all(5.0),
                                                  padding: EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      color: ContainerColor),
                                                  child: Center(
                                                    child: Text(
                                                      postList.status!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                        //backgroundColor: Colors.red
                                                      ),
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
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(5.0),
                                                      child: Text(
                                                        postList.userName.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
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
                                                        final urlImage = "${masterUrl}${postList.imagePath}";
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
                                                                "Download link https://play.google.com/store/apps/details?id=com.aleyia_azadari_schedule \n"
                                                                "🔊 ${postList.cityName} \n \n \n"
                                                                "▪️Scholar/Event:- ${postList.nameOfSchollar} \n"
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
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),

                        onRefresh: () async{
                          await Future.delayed(Duration(milliseconds: 1000));
                          setState(() {
                            isRefersh = true;
                            currentPage = 1;
                          });
                        },

                        onLoading: () async {
                          if(currentPage == snapshot.data!.pages){
                            refreshController.loadNoData();
                          }else{
                            setState(() {
                              currentPage++;
                            });
                            // await Future.delayed(Duration(milliseconds: 1000));
                            // refreshController.loadComplete();
                          }

                        },

                      );
                    } else if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: Image.asset('assets/Ovals.gif'),
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

  Future<void> _showDeleteDialog(String? refId, String? imagePath) async {
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
                deletePost(refId,imagePath);
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


  Future<void> deletePost(String? refId, String? imagePath) async {
    //var url = "https://aeliya.000webhostapp.com/deletePost.php?refId=$refId";
    var url = "${masterUrl}deletePost.php?refId=$refId";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
        DeleteImage(refId, imagePath);
      // Fluttertoast.showToast(msg: "Deleted successfully",
      //     backgroundColor: Color(hexColors("006064")));
    } else {
      Fluttertoast.showToast(msg: "something went wrong",
          backgroundColor: Color(hexColors("006064")));
    }
  }

  Future DeleteImage(String? refId, String? imagePath) async {

    var url = Uri.parse("${masterUrl}deletePost.php?refId=$refId");


    Map mapeddate = {
      'imgPath': imagePath
    };
    print("JSON DATA : ${mapeddate}");
    http.Response response = await http.post(url, body: mapeddate);

    if (response.statusCode == 200) {
        dummyData.data!.clear();
      var data = jsonDecode(response.body);
      print("Data:- $data");
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Deleted successfully",
          backgroundColor: Color(hexColors("006064")));
    } else {
      print("failed");
      Fluttertoast.showToast(msg: "Some thing went wrong",
          backgroundColor: Color(hexColors("006064")));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

}
