import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;
import '../../Models/Hexa color.dart';
import '../../Models/LinkModel.dart';

class fullScreen extends StatefulWidget {
  const fullScreen({Key? key}) : super(key: key);

  @override
  State<fullScreen> createState() => _fullScreenState();
}

class _fullScreenState extends State<fullScreen> {

  late YoutubePlayerController _controller;

  Future<LinkModel> getAllLinks() async {
    var url = "https://aeliya.000webhostapp.com/MajlisLinks.php";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    print("****" + jsondata.toString());

    if (response.statusCode == 200) {
      return LinkModel.fromJson(jsondata);
    } else {
      return LinkModel.fromJson(jsondata);
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
              body: FutureBuilder<LinkModel>(
                future: getAllLinks(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.data!.length-1,
                        itemBuilder: (context, index){
                      var allItem = snapshot.data!.data![index];
                      var videoId = allItem.link!.substring(17);
                      print("///////////////////");
                      print(videoId);
                      return Card(
                        color: Color(hexColors("03A9F4")),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10.0)),
                        child: Expanded(
                          child: Column(
                            children: [
                             YoutubePlayer(
                               controller: _controller = YoutubePlayerController.fromVideoId(videoId: videoId,
                               autoPlay: false,
                               params: YoutubePlayerParams(showFullscreenButton: true ))
                                 ),


                            ],
                          ),
                        ),

                      );
                    }
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
