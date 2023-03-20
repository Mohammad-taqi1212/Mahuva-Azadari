import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;
import '../../Models/Hexa color.dart';
import '../../Models/LinkModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

class fullScreen extends StatefulWidget {
  const fullScreen({Key? key}) : super(key: key);

  @override
  State<fullScreen> createState() => _fullScreenState();
}

class _fullScreenState extends State<fullScreen> {
  late Stream<LinkModel> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await getAllLinks());

  late YoutubePlayerController _controller;
  final RefreshController refreshController = RefreshController();
  int currentPage = 1;
  bool isRefersh = false;
  Color? ContainerColor;

  LinkModel dummyData = LinkModel();

  Future<LinkModel> getAllLinks() async {
    var url =
        //"https://aeliya.000webhostapp.com/MajlisLinks.php?page=$currentPage";
        "${masterUrl}MajlisLinks.php?page=$currentPage";
    var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 20),
        onTimeout: () {
      Fluttertoast.showToast(
          msg: "Server time out", backgroundColor: Color(hexColors("006064")));
      return http.Response('Error', 408);
    });
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = LinkModel.fromJson(jsondata);

    var newData = [...?dummyData.data, ...?_apiData.data];

    if (response.statusCode == 200) {
      if (isRefersh == true) {
        setState(() {
          isRefersh = false;
        });
        refreshController.refreshCompleted();
      } else {
        if (_apiData.hasNextPage == 0) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        final refids = newData.map((e) => e.refId).toSet();
        newData.retainWhere((ids) => refids.remove(ids.refId));
        //dummyData.data = newData.toSet().toList();
        dummyData.data = newData;
        print(newData.toString());
      }
      return dummyData;
    } else {
      return dummyData;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
        // onEnterFullscreen: _onEnterFullScreen,
        // onExitFullscreen: _onExitFullScreen,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
  }

  // void _onEnterFullScreen() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // }
  //
  // void _onExitFullScreen() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  // }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Live Program",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            centerTitle: true,
            backgroundColor: Color(hexColors('006064')),
          ),
          body: StreamBuilder<LinkModel>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  child: ListView.builder(
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index) {
                        var allItem = snapshot.data!.data![index];

                        //following regex for both link live and not live
                        RegExp regExp = new RegExp(
                            r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|live\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
                            caseSensitive: false,
                            multiLine: false);

                        //following regexp for only non live youtube video
                        // RegExp regExp = new RegExp(
                        //   r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
                        //   caseSensitive: false,
                        //   multiLine: false,
                        // );
                        final match = regExp
                            .firstMatch(allItem.link.toString())!
                            .group(1);
                        var videoId = match;

                        if (allItem.status == "Ongoing") {
                          ContainerColor = Colors.green;
                        } else if (allItem.status == "Upcoming") {
                          ContainerColor = Colors.blue;
                        } else {
                          ContainerColor = Colors.red;
                        }

                        //var videoId = allItem.link!.substring(17);
                        return Card(
                          color: Color(hexColors("009688")),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),

                          child: Column(
                            children: [
                              YoutubePlayer(
                                controller: _controller =
                                    YoutubePlayerController.fromVideoId(
                                        videoId: videoId.toString(),
                                        autoPlay: false,
                                        params: YoutubePlayerParams(
                                            showFullscreenButton: true)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100,
                                      margin: EdgeInsets.all(5.0),
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.white),
                                          color: ContainerColor),
                                      child: Center(
                                        child: Text(
                                          allItem.status!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                              //backgroundColor: Colors.red
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "City :- ${allItem.city}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        allItem.username.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      allItem.postDateTime.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await Share.share(
                                              "${allItem.link.toString()} \n \n"
                                              "For all Live program app Download link https://play.google.com/store/apps/details?id=com.aleyia_azadari_schedule \n");
                                        },
                                        icon: Icon(Icons.share,
                                            color: Colors.white))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 1000));
                    setState(() {
                      isRefersh = true;
                      currentPage = 1;
                    });
                  },
                  onLoading: () async {
                    print(
                        "**********************************************************");
                    print(snapshot.data!.hasNextPage.toString());
                    if (snapshot.data!.hasNextPage == 0) {
                      refreshController.loadNoData();
                    } else {
                      setState(() {
                        currentPage++;
                      });
                      // await Future.delayed(Duration(milliseconds: 1000));
                      // refreshController.loadComplete();
                    }
                  },
                );
              } else {
                return Container(
                  child: Center(
                    child: Image.asset('assets/Ovals.gif'),
                  ),
                );
              }
            },
          ),
        ));
      },
    );
  }
}
