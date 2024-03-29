import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Models/AllMayyatNewsModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../Models/Hexa color.dart';
import 'package:http/http.dart' as http;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'Home.dart';
import 'package:share_plus/share_plus.dart';

class MayyatNews extends StatefulWidget {
  const MayyatNews({Key? key}) : super(key: key);

  @override
  State<MayyatNews> createState() => _MayyatNewsState();
}

class _MayyatNewsState extends State<MayyatNews> {

  late Stream<AllMayyatNewsModel> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await getMayyatNews());


  int currentPage = 1;
  bool isRefersh = false;
  final RefreshController refreshController = RefreshController();

  bool showSearchBar = false;
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  bool showFlaotingButton = true;

  AllMayyatNewsModel dummyData = AllMayyatNewsModel();

  Future<AllMayyatNewsModel> getMayyatNews() async {
    var url =
        //"https://aeliya.000webhostapp.com/getMayyatNews.php?page=$currentPage";
        "${masterUrl}getMayyatNews.php?page=$currentPage";
    var response = await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 20),
        onTimeout: (){
          Fluttertoast.showToast(msg: "Server time out",
              backgroundColor: Color(
                  hexColors("006064")));
          return http.Response('Error', 408);
        }
    );
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = AllMayyatNewsModel.fromJson(jsondata);

    var newData = [...?dummyData.data, ...?_apiData.data];

    if (response.statusCode == 200) {
      if(isRefersh == true){
        setState((){
          isRefersh = false;
        });
        refreshController.refreshCompleted();
      }
      else{
        if(_apiData.hasNextPage == 0){
          refreshController.loadNoData();
        }else{
          refreshController.loadComplete();
        }
        final refids = newData.map((e) => e.refId).toSet();
        newData.retainWhere((ids) => refids.remove(ids.refId));
        //dummyData.data = newData.toSet().toList();
        dummyData.data = newData;
      }
      return dummyData;
    } else {
      return dummyData;;
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(
      backgroundColor: Color(hexColors('006064')),
      title: Text(
        "Mayyat News",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          //color: Colors.black
        ),
      ),
      centerTitle: true,
    ),
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
                    child: StreamBuilder<AllMayyatNewsModel>(
                      stream: stream,
                      builder: (context,AsyncSnapshot<AllMayyatNewsModel> snapshot) {
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
                                      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                                      child: Material(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          //color: Color(hexColors("009688")),
                                          // elevation: 6,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //     BorderRadius.circular(10.0)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.black),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color(hexColors("009688")),
                                                  //Colors.blueAccent,
                                                  Color(hexColors("4DB6AC")),
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
                                                    ]
                                                  ),),
                                              ExpansionTile(
                                                collapsedIconColor: Colors.white,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
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


                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                          child: Text(
                                                            postList.username
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                        child: Text(
                                                            postList.postTime
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white)),
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

                                  } else if (tempSearch.toLowerCase().contains(
                                      searchController.text.toString())) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                                      child: Material(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          //color: Color(hexColors("009688")),
                                          // elevation: 6,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //     BorderRadius.circular(10.0)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.black),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color(hexColors("009688")),
                                                  //Colors.blueAccent,
                                                  Color(hexColors("4DB6AC")),
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


                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                        child: Text(
                                                          postList.username
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                        child: Text(
                                                            postList.postTime
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white)),
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
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
                              if(snapshot.data!.hasNextPage == 0){
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
                            child: Text("Some thing went wrong !"),
                          );
                        }
                        else {
                          return Center(
                            child: Text("Some thing went wrong !"),
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
            padding: const EdgeInsets.only(top: 70.0),
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
}
