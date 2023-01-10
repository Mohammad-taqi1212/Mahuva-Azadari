import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mahuva_azadari/Models/LinkModel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../../Models/Hexa color.dart';

class LiveProgram extends StatefulWidget {
  const LiveProgram({Key? key}) : super(key: key);

  @override
  State<LiveProgram> createState() => _LiveProgramState();
}

class _LiveProgramState extends State<LiveProgram> {

  String? title;

  late YoutubePlayerController _youtubePlayerController;
  void initState(){
    super.initState();
    _youtubePlayerController = YoutubePlayerController(initialVideoId: '');
  }



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
  void deactive() {
    _youtubePlayerController.pause();
    super.deactivate();
    print("deactivate");
  }

  @override
  void dipose() {
    _youtubePlayerController.dispose();
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubePlayerController,
        aspectRatio:16/9,
      ),
      builder: (context,player){
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
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index){
                        var allItem = snapshot.data!.data![index];
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Card(
                            color: Color(hexColors("03A9F4")),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            child: Column(
                              children: [
                                YoutubePlayer(
                                  controller: _youtubePlayerController = YoutubePlayerController(
                                    initialVideoId: YoutubePlayer.convertUrlToId(allItem.link!).toString(),
                                    flags: YoutubePlayerFlags(
                                      autoPlay: false,
                                    ),
                                  ),
                                  //   ..addListener(() {
                                  //   if(mounted){
                                  //     setState(() {});
                                  //   }
                                  // }),
                                  showVideoProgressIndicator: true,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Text("Channel Name:-  ${allItem.channelName!}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(onPressed: (){
                                      _youtubePlayerController.toggleFullScreenMode();
                                    },
                                        icon: Icon(Icons.fullscreen))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text("City : ${allItem.city!}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),),
                                      ),
                                    ),
                                  ],
                                ),
                                // Text(_youtubePlayerController.metadata.title.isEmpty? 'Loading Title.....' :
                                // "Title: " +_youtubePlayerController.metadata.title,
                                //   textAlign: TextAlign.left,
                                //   style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.w700,
                                //       fontStyle: FontStyle.italic),
                                // ),

                                //SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(allItem.username.toString(),
                                        style: TextStyle(color: Colors.white),),
                                      Text(allItem.postDateTime.toString(),
                                        style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                )
                              ],
                            ),

                          ),
                        );
                      });
                }else if(snapshot.connectionState == ConnectionState.waiting){
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
            ),
          ),
        );
      },
    );
  }
}
