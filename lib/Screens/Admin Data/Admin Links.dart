import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Models/AdminLinksModel.dart';
import 'package:mahuva_azadari/Screens/Post%20Edit/Edit%20Links.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/Hexa color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';



class AdminLinks extends StatefulWidget {
  const AdminLinks({Key? key}) : super(key: key);

  @override
  State<AdminLinks> createState() => _AdminLinksState();
}

class _AdminLinksState extends State<AdminLinks> {

  late Stream<AdminLinksModel> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await getAdminLinks());

  late YoutubePlayerController _controller;

  String? title;

  late YoutubePlayerController _youtubePlayerController;
  void initState(){
    super.initState();

    _controller = YoutubePlayerController(
        params: YoutubePlayerParams(
          showControls: true,
          mute: false,
          showFullscreenButton: true,
          loop: false,
        )
    );

    _controller.setFullScreenListener(
          (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );

  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }


  int currentPage = 1;
  AdminLinksModel dummyData = AdminLinksModel();
  bool isRefersh = false;
  final RefreshController refreshController = RefreshController();


  Future<AdminLinksModel> getAdminLinks() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');

    //var url = "https://aeliya.000webhostapp.com/adminLinks.php?id=$getUserId&pageNo=$currentPage";
    var url = "${masterUrl}adminLinks.php?id=$getUserId&pageNo=$currentPage";
    print(url);
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = AdminLinksModel.fromJson(jsondata);

    var newData = [...?dummyData.data, ...?_apiData.data];


    if (response.statusCode == 200) {

      if(isRefersh == true){
        setState((){
          isRefersh = false;
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
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context,player){
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: StreamBuilder<AdminLinksModel>(
              stream: stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return SmartRefresher(
                    controller: refreshController,
                    enablePullUp: true,
                    child: ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index){
                          var allItem = snapshot.data!.data![index];
                          //following regex for both link live and not live
                          RegExp regExp = new RegExp(r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|live\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
                              caseSensitive: false, multiLine: false);
                          final match = regExp.firstMatch(allItem.link.toString())!.group(1);
                          var videoId = match;



                          return Card(
                            color: Color(hexColors("03A9F4")),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            child: Column(
                              children: [
                                YoutubePlayer(
                                    controller: _controller = YoutubePlayerController.fromVideoId(videoId: videoId.toString(),
                                        autoPlay: false,
                                        params: YoutubePlayerParams(showFullscreenButton: true ))
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text("City :- ${allItem.city}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),),
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
                                                  var elink = allItem.link;
                                                  var ecity = allItem.city;
                                                  var refid = allItem.refId;

                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context)=> EditLinks(
                                                          elink!,ecity!,refid!
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
                                                  _showDeleteDialog(allItem.refId);
                                                },
                                                icon: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(onPressed: () async{
                                            await Share.share("${allItem.link.toString()} \n"
                                                "Download link https://play.google.com/store/apps/details?id=com.aleyia_azadari_schedule \n");
                                          },
                                              icon: Icon(Icons.share,color: Colors.white))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //     MainAxisAlignment.end,
                                //     children: [
                                //       Container(
                                //         decoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color:
                                //                 Colors.white),
                                //             shape: BoxShape.circle),
                                //         child: IconButton(
                                //             onPressed: () {
                                //               print("edit tap");
                                //               var elink = allItem.link;
                                //               var ecity = allItem.city;
                                //               var refid = allItem.refId;
                                //
                                //               Navigator.push(context,
                                //                   MaterialPageRoute(builder: (context)=> EditLinks(
                                //                       elink!,ecity!,refid!
                                //                   )));
                                //             },
                                //             icon: Icon(
                                //               Icons.edit,
                                //               color: Colors.yellow,
                                //             )),
                                //       ),
                                //       SizedBox(
                                //         width: 5,
                                //       ),
                                //       Container(
                                //         decoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color:
                                //                 Colors.white),
                                //             shape: BoxShape.circle),
                                //         child: IconButton(
                                //             onPressed: () {
                                //               print("delete tap");
                                //               _showDeleteDialog(allItem.refId);
                                //             },
                                //             icon: Icon(
                                //               Icons.delete_forever,
                                //               color: Colors.red,
                                //             )),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(10.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Text(allItem.username.toString()),
                                //       Text(allItem.postDateTime.toString()),
                                //       IconButton(onPressed: () async{
                                //         await Share.share(allItem.link.toString());
                                //       },
                                //           icon: Icon(Icons.share,color: Colors.white))
                                //     ],
                                //   ),
                                // )
                              ],
                            ),

                          );
                        }
                    ),

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
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
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
            ),
          ),
        );
      },
    );
  }

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
    //var url = "https://aeliya.000webhostapp.com/deleteLink.php?refId=$refId";
    var url = "${masterUrl}deleteLink.php?refId=$refId";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      dummyData.data!.clear();
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Deleted successfully",
          backgroundColor: Color(hexColors("006064")));
    } else {
      Fluttertoast.showToast(msg: "something went wrong",
          backgroundColor: Color(hexColors("006064")));
    }
  }
}
