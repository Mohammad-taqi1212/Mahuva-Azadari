import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Screens/Post%20Edit/Edit%20Links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../../Models/Hexa color.dart';
import '../../Models/getAdminLInks.dart';

class AdminLinks extends StatefulWidget {
  const AdminLinks({Key? key}) : super(key: key);

  @override
  State<AdminLinks> createState() => _AdminLinksState();
}

class _AdminLinksState extends State<AdminLinks> {

  late Stream<GetAdminLInks> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await getAdminLinks());

  String? title;

  late YoutubePlayerController _youtubePlayerController;
  void initState(){
    super.initState();
    _youtubePlayerController = YoutubePlayerController(initialVideoId: '');
  }



  Future<GetAdminLInks> getAdminLinks() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var getUserId = sharedPreferences.getString('currentUserid');

    var url = "https://aeliya.000webhostapp.com/adminLinks.php?id=$getUserId";
    print(url);
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    print(jsondata);

    if (response.statusCode == 200) {
      print("****" + jsondata.toString());
      return GetAdminLInks.fromJson(jsondata);
    } else {
      return GetAdminLInks.fromJson(jsondata);
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
      ),
      builder: (context,player){
        return SafeArea(
          child: Scaffold(
            body: StreamBuilder<GetAdminLInks>(
              stream: stream,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
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
                                              var echannel = allItem.channelName;
                                              var refid = allItem.refId;

                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context)=> EditLinks(
                                                    elink!,ecity!,echannel!,refid!
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
    var url = "https://aeliya.000webhostapp.com/deleteLink.php?refId=$refId";
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
