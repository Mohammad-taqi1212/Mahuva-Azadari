import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Screens/Post%20Edit/Edit%20M_News.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/AdminMayyatModel.dart';
import '../../Models/Hexa color.dart';
import 'package:http/http.dart' as http;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:share_plus/share_plus.dart';

import '../Drawer/Home.dart';


class AdminMnews extends StatefulWidget {
  const AdminMnews({Key? key}) : super(key: key);

  @override
  State<AdminMnews> createState() => _AdminMnewsState();
}

class _AdminMnewsState extends State<AdminMnews> {

  late Stream<AdminMayyatModel> stream = Stream.periodic(Duration(seconds: 1))
      .asyncMap((event) async => await getMayyatNews());


  int currentPage = 1;
  bool isRefersh = false;
  final RefreshController refreshController = RefreshController();

  bool showSearchBar = false;
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  bool showFlaotingButton = true;

  AdminMayyatModel dummyData = AdminMayyatModel();


  Future<AdminMayyatModel> getMayyatNews() async {

    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');

    var url =
        //"https://aeliya.000webhostapp.com/adminMayyatNews.php?id=$getUserId&pageNo=$currentPage";
        "${masterUrl}adminMayyatNews.php?id=$getUserId&pageNo=$currentPage";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = AdminMayyatModel.fromJson(jsondata);

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
      return dummyData;
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      helpText: "Search by Name",
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
                    child: StreamBuilder<AdminMayyatModel>(
                      stream: stream,
                      builder: (context,AsyncSnapshot<AdminMayyatModel> snapshot) {
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
                                  postList.name.toString();


                                  if (searchController.text.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        color: Color(hexColors("009688")),
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
                                                    child: chekImage(postList.imagePath.toString()),
                                                  )),
                                              title: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "M.Name: ",
                                                          Hdetail: postList
                                                              .name
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "City: ",
                                                          Hdetail: postList
                                                              .city
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "Date: ",
                                                          Hdetail: postList.date
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "Mayyt Time: ",
                                                          Hdetail: postList.mayyatTime
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "Namaze Mayyat: ",
                                                          Hdetail: postList
                                                              .namazTime
                                                              .toString(),
                                                        ),
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
                                                               //"https://aeliya.000webhostapp.com/${postList.imagePath!}"
                                                                var img = postList.imagePath;
                                                                var Mname = postList.name;
                                                                var city = postList.city;
                                                                var date = postList.date;
                                                                var Mtime = postList.mayyatTime;
                                                                var Ntime = postList.namazTime;
                                                                var address = postList.address;
                                                                var refid = postList.refId;

                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=> EditMnews(
                                                                    img!,Mname!,city!,date!,Mtime!,Ntime!,address!,refid!
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
                                                        //for share post to other app
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                          child: IconButton(
                                                            icon: Icon(Icons.share,color: Colors.white,),
                                                            onPressed: () async{

                                                              if (postList.imagePath == ""){
                                                                await Share.share(subject:
                                                                "إِنَّا لِلَّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُون",
                                                                    "⬛ إِنَّا لِلَّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُون ⬛"
                                                                        "\n \n 🔊 Azadari Schedule App  \n"
                                                                        "Download link https://play.google.com/store/apps/details?id=com.aleyia_azadari_schedule \n"
                                                                        "🔊 ${postList.city} \n \n \n"
                                                                        "▪️Marhum:- ${postList.name} \n"
                                                                        "▪️City:- ${postList.city} \n"
                                                                        "▪️Date:- ${postList.date} \n"
                                                                        "▪️Mayyat Time:- ${postList.mayyatTime}\n"
                                                                        "▪️Namaze Mayyat:- ${postList.namazTime} \n"
                                                                        "▪️Address:- ${postList.address} \n \n \n"
                                                                );

                                                              }else{
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
                                                                        "🔊 ${postList.city} \n \n \n"
                                                                        "▪️Marhum:- ${postList.name} \n"
                                                                        "▪️City:- ${postList.city} \n"
                                                                        "▪️Date:- ${postList.date} \n"
                                                                        "▪️Mayyat Time:- ${postList.mayyatTime}\n"
                                                                        "▪️Namaze Mayyat:- ${postList.namazTime} \n"
                                                                        "▪️Address:- ${postList.address} \n \n \n"
                                                                        "✅ For daily majlis update please download our app from play store"
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]
                                              ),),
                                            ExpansionTile(
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: const [
                                                  Text(
                                                    "Address:",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        fontStyle:
                                                        FontStyle.italic,
                                                        decoration: TextDecoration
                                                            .underline),
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
                                                      BorderRadius.circular(
                                                          10),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Text(postList.address.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                        FontStyle.italic,
                                                        fontSize: 18),
                                                  ),
                                                ),


                                                // Row(
                                                //   mainAxisAlignment:
                                                //   MainAxisAlignment
                                                //       .spaceBetween,
                                                //   children: [
                                                //     Padding(
                                                //       padding:
                                                //       const EdgeInsets.all(
                                                //           5.0),
                                                //       child: Text(
                                                //         postList.username
                                                //             .toString(),
                                                //         style: TextStyle(
                                                //             color: Colors.white),
                                                //       ),
                                                //     ),
                                                //     Padding(
                                                //       padding:
                                                //       const EdgeInsets.all(
                                                //           5.0),
                                                //       child: Text(
                                                //           postList.postTime
                                                //               .toString(),
                                                //           style: TextStyle(
                                                //               color:
                                                //               Colors.white)),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                  } else if (tempSearch.toLowerCase().contains(
                                      searchController.text.toString().trim())) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        color: Color(hexColors("009688")),
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
                                                    child: chekImage(postList.imagePath.toString()),
                                                  )),
                                              title: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "M.Name: ",
                                                          Hdetail: postList
                                                              .name
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "City: ",
                                                          Hdetail: postList
                                                              .city
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "Date: ",
                                                          Hdetail: postList.date
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "Mayyt Time: ",
                                                          Hdetail: postList.mayyatTime
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        titleStyle(
                                                          Htitle: "Namaze Mayyat: ",
                                                          Hdetail: postList
                                                              .namazTime
                                                              .toString(),
                                                        ),
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
                                                                //"https://aeliya.000webhostapp.com/${postList.imagePath!}"
                                                                var img = postList.imagePath;
                                                                var Mname = postList.name;
                                                                var city = postList.city;
                                                                var date = postList.date;
                                                                var Mtime = postList.mayyatTime;
                                                                var Ntime = postList.namazTime;
                                                                var address = postList.address;
                                                                var refid = postList.refId;

                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=> EditMnews(
                                                                    img!,Mname!,city!,date!,Mtime!,Ntime!,address!,refid!
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
                                                        //for share post to other app
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                          child: IconButton(
                                                            icon: Icon(Icons.share,color: Colors.white,),
                                                            onPressed: () async{

                                                              if (postList.imagePath == null){
                                                                await Share.share(subject:
                                                                "إِنَّا لِلَّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُون",
                                                                    "⬛ إِنَّا لِلَّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُون ⬛"
                                                                        "\n \n 🔊 Azadari Schedule App  \n"
                                                                        "Download link https://play.google.com/store/apps/details?id=com.aleyia_azadari_schedule \n"
                                                                        "🔊 ${postList.city} \n \n \n"
                                                                        "▪️Marhum:- ${postList.name} \n"
                                                                        "▪️City:- ${postList.city} \n"
                                                                        "▪️Date:- ${postList.date} \n"
                                                                        "▪️Mayyat Time:- ${postList.mayyatTime}\n"
                                                                        "▪️Namaze Mayyat:- ${postList.namazTime} \n"
                                                                        "▪️Address:- ${postList.address} \n \n \n"
                                                                        "✅ For daily majlis update please download our app from play store"
                                                                );

                                                              }else{
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
                                                                        "🔊 ${postList.city} \n \n \n"
                                                                        "▪️Marhum:- ${postList.name} \n"
                                                                        "▪️City:- ${postList.city} \n"
                                                                        "▪️Date:- ${postList.date} \n"
                                                                        "▪️Mayyat Time:- ${postList.mayyatTime}\n"
                                                                        "▪️Namaze Mayyat:- ${postList.namazTime} \n"
                                                                        "▪️Address:- ${postList.address} \n \n \n"
                                                                        "✅ For daily majlis update please download our app from play store"
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]
                                              ),),
                                            ExpansionTile(
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: const [
                                                  Text(
                                                    "Address:",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        fontStyle:
                                                        FontStyle.italic,
                                                        decoration: TextDecoration
                                                            .underline),
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
                                                      BorderRadius.circular(
                                                          10),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Text(postList.address.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                        FontStyle.italic,
                                                        fontSize: 18),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  else {
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
                        }else if(snapshot.connectionState == ConnectionState.waiting){
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
                    )),
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
        )
    );
  }

  chekImage(String imagepath) {
    if (imagepath == "") {
      print("null");
      print(imagepath);
      return
        Image.asset('assets/appIcon.png');
    } else {
      print("not null");
      print(imagepath);
      return
        Image.network("${masterUrl}" + imagepath);
    }
  }

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
    //var url = "https://aeliya.000webhostapp.com/deleteMayyatNews.php?refId=$refId"";
    var url = "${masterUrl}deleteMayyatNews.php?refId=$refId";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      if(imagePath!.isEmpty){
        dummyData.data!.clear();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Deleted successfully",
            backgroundColor: Color(hexColors("006064")));
      }else{
        DeleteImage(refId,imagePath);
      }
    } else {
      Fluttertoast.showToast(msg: "something went wrong",
          backgroundColor: Color(hexColors("006064")));
    }
  }


  Future DeleteImage(String? refId, String? imagePath) async {

    var url = Uri.parse("${masterUrl}deleteMayyatNews.php?refId=$refId");

    Map mapeddate = {
      'imgPath': imagePath
    };
    print("JSON DATA : ${mapeddate}");
    http.Response response = await http.post(url, body: mapeddate);

    if (response.statusCode == 200) {
      dummyData.data!.clear();
      // ignore: use_build_context_synchronously
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
