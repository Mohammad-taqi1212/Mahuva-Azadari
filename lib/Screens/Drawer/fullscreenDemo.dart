import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
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

  LinkModel dummyData = LinkModel();

  Future<LinkModel> getAllLinks() async {
    var url = "https://aeliya.000webhostapp.com/MajlisLinks.php?page=$currentPage";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = LinkModel.fromJson(jsondata);


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

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return SafeArea(
            child: Scaffold(
              appBar: AppBar(title: Text("Live Program",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),),
                centerTitle: true,
                backgroundColor: Color(hexColors('006064')),
              ),
              body: StreamBuilder<LinkModel>(
                stream: stream,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return SmartRefresher(
                      controller: refreshController,
                      enablePullUp: true,
                      child: ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index){
                        var allItem = snapshot.data!.data![index];
                        var videoId = allItem.link!.substring(17);
                        return Card(
                          color: Color(hexColors("03A9F4")),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0)),
                          child: Column(
                            children: [
                             YoutubePlayer(
                               controller: _controller = YoutubePlayerController.fromVideoId(videoId: videoId,
                               autoPlay: false,
                               params: YoutubePlayerParams(showFullscreenButton: true ))
                                 ),
                              SizedBox(height: 5,),
                              Text("City :- ${allItem.city}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(allItem.username.toString()),
                                    Text(allItem.postDateTime.toString()),
                                    IconButton(onPressed: () async{
                                      await Share.share(allItem.link.toString());
                                    },
                                        icon: Icon(Icons.share,color: Colors.white))
                                  ],
                                ),
                              )
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
                        print("**********************************************************");
                        print(snapshot.data!.hasNextPage.toString());
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
                  }else{
                    return Container(child: Center(child: CircularProgressIndicator(),),);
                  }

                },
              ),
            )
        );
      },
    );
}
}
