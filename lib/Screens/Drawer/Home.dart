import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mahuva_azadari/Models/Hexa%20color.dart';
import 'package:mahuva_azadari/Models/Notification_badge.dart';
import 'package:mahuva_azadari/Models/Push%20Notification.dart';
import 'package:mahuva_azadari/Screens/Drawer/Admin%20Request.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/AdminPannel.dart';
import 'package:mahuva_azadari/Screens/Drawer/Contact%20Us.dart';
import 'package:mahuva_azadari/Screens/Drawer/Live.dart';
import 'package:mahuva_azadari/Screens/Drawer/MayyatNews.dart';
import 'package:mahuva_azadari/Screens/Drawer/URL%20calendar.dart';
import 'package:mahuva_azadari/Screens/Drawer/fullscreenDemo.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Exit POPup.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../Models/UserPostModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Stream<UserPostModel> stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await getUserPost());

  //initialize some value
  late final FirebaseMessaging _messaging;
  late int _totoalNotificatinCounter;


  //model
  pushNotification? _notificationInfo;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    //Normal notification
    _totoalNotificatinCounter = 0;
    registerNotification();

  }


  String searchText = "";
  TextEditingController searchController = TextEditingController();
  bool isVisible = false;
  String ComparisonText = "";
  Color? ContainerColor;
  bool showSearchBar = false;
  bool showFlaotingButton = true;
  String itemFilter = "";
  bool isFilter = false;


  int currentPage = 1;
  bool isRefersh = false;
  int? totalPage;
  final RefreshController refreshController = RefreshController();


  Future<UserPostModel> getUserPost() async {

    var url =
        "https://aeliya.000webhostapp.com/getUserPost.php?page=$currentPage";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body.toString());
    var _apiData = UserPostModel.fromJson(jsondata);

    //totalPage = _apiData.totalPages as int?;

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
      }
      return UserPostModel.fromJson(jsondata);

    } else {
      return UserPostModel.fromJson(jsondata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            //tap any where to close keyboard
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            drawer: Drawer(
              child: Container(
                decoration: BoxDecoration(color: Color(hexColors("0097A7"))),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 250,
                      child: DrawerHeader(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/flag imam hussain.png"),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                "Azadari Schedule",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          )),
                    ),
                    //********body of drawer*********
                    Column(
                      children: [
                        ReusableDrawer(
                          title: "Live Program",
                          icon: Icon(
                            Icons.live_tv,
                            //color: Colors.black,
                            //size: 35,
                          ),
                          onTap: () {
                            setState(() {
                              currentPage =1;
                            });
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => fullScreen()));
                          },
                        ),
                        ReusableDrawer(
                          title: "Mayyat News",
                          icon: Icon(
                            Icons.newspaper_rounded,
                            //size: 35,
                          ),
                          onTap: () {
                            setState(() {
                              currentPage =1;
                            });
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MayyatNews()));
                          },
                        ),
                        ReusableDrawer(
                          title: "Admin Profile",
                          icon: Icon(
                            Icons.person_add,
                            //size: 35,
                          ),
                          onTap: () async {
                            setState(() {
                              currentPage =1;
                            });
                            Navigator.pop(context);

                            final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                            var isLogin = sharedPreferences.getBool('isLogin');
                            if (isLogin != null) {
                              if (isLogin == true) {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminPannel()));
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminReq()));
                              }
                            } else {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminReq()));
                            }
                          },
                        ),
                        ReusableDrawer(
                          title: "Rate Us",
                          icon: Icon(
                            Icons.star_rate_outlined,
                            //size: 35,
                          ),
                          onTap: () {
                            setState(() {
                              currentPage =1;
                            });
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ratingStar()));
                            StoreRedirect.redirect(
                                androidAppId: "com.example.mahuva_azadari"
                            );
                          },
                        ),
                        ReusableDrawer(
                          title: "Contact Us",
                          icon: Icon(
                            Icons.contact_mail,
                            //size: 35,
                          ),
                          onTap: () async{
                            setState(() {
                              currentPage=1;
                            });
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUs()));
                          },
                        ),
                        ReusableDrawer(
                          title: "Calender",
                          icon: Icon(
                            Icons.calendar_month,
                            //size: 35,
                          ),
                          onTap: () async{
                            setState(() {
                              currentPage=1;
                            });
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => URLCalender()));

                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color(hexColors('006064')),
              title: Text(
                "Program Schedule",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  //color: Colors.black
                ),
              ),
              centerTitle: true,
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.filter_list_sharp),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text("Ongoing"),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text("Upcoming"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("Past"),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Text("All"),
                    ),
                  ],
                  onSelected: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (value == 0) {

                    } else if (value == 1) {

                    } else if (value == 2) {

                    } else {

                    }
                  },
                ),
              ],
            ),
            //backgroundColor: Color(hexColors("8E24AA")),
            body: SafeArea(
              child: Padding(
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
                          //textFieldColor: Colors.grey.shade300,
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
                              isFilter = false;
                            });
                          },
                        ),
                      ),
                      //child: Container()
                    ),
                    Expanded(
                        child: StreamBuilder<UserPostModel>(
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



                                     /* // //for date comparison
                                      DateTime stdt = DateFormat('dd-MM-yyyy')
                                          .parse(postList.startDate.toString());
                                      DateTime endt = DateFormat('dd-MM-yyyy')
                                          .parse(postList.endDate.toString());
                                      DateTime curr1 = DateTime.now();
                                      DateTime crdt = new DateFormat("yyyy-MM-dd").parse(curr1.toString());


                                       if (stdt.isBefore(crdt)) {
                                        //past
                                        if (endt.isBefore(crdt)) {
                                          ComparisonText = "Past";
                                          ContainerColor = Colors.red;
                                          myList.add("Past");
                                        } else if (endt.isAtSameMomentAs(crdt)) {
                                          ComparisonText = "Ongoing";
                                          ContainerColor = Colors.green;
                                          myList.add("Ongoing");
                                        } else {
                                          ComparisonText = "Ongoing";
                                          ContainerColor = Colors.green;
                                          myList.add("Ongoing");
                                        }
                                      } else if (stdt.isAfter(crdt)) {
                                        //upcoming
                                        ComparisonText = "Upcoming";
                                        ContainerColor = Colors.blue;
                                        myList.add("Upcoming");
                                      } else if (stdt.isAtSameMomentAs(crdt)){
                                        ComparisonText = "Ongoing";
                                        ContainerColor = Colors.green;
                                        myList.add("Ongoing");
                                      }
                                      else {
                                        //ongoing
                                        ComparisonText = "Ongoing";
                                        ContainerColor = Colors.green;
                                        myList.add("Ongoing");
                                      }*/

                                      if(postList.status == "Ongoing"){
                                        ContainerColor = Colors.green;
                                      }else if(postList.status == "Upcoming"){
                                        ContainerColor = Colors.blue;
                                      }else{
                                        ContainerColor = Colors.red;
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
                                                            titleStyle(
                                                              Htitle: "Scholar: ",
                                                              Hdetail: postList
                                                                  .nameOfSchollar
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            titleStyle(
                                                              Htitle: "Program: ",
                                                              Hdetail: postList
                                                                  .programList
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
                                                                Hdetail:
                                                                "${postList.startDate} TO  ${postList.endDate}"),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            titleStyle(
                                                              Htitle: "Time: ",
                                                              Hdetail: postList.time
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            titleStyle(
                                                              Htitle: "Azakhana: ",
                                                              Hdetail: postList
                                                                  .azakhanaName
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
                                                                  .cityName
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                ExpansionTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(5.0),
                                                        padding: EdgeInsets.all(5.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                            border: Border.all(
                                                                color: Colors.white),
                                                            color: ContainerColor),
                                                        child: Text(
                                                          postList.status!,
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
                                                      child: Text(
                                                        postList.description
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontStyle:
                                                            FontStyle.italic,
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
                                                          decoration: TextDecoration
                                                              .underline),
                                                    ),
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
                                                      child: Text(
                                                        postList.specialNotes
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontStyle:
                                                            FontStyle.italic,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
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
                                                            postList.userName
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
                                                              postList.postDateTime
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

                                      } else if (tempSearch.toLowerCase().contains(
                                          searchController.text.toString())) {
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
                                                            titleStyle(
                                                              Htitle: "Scholar: ",
                                                              Hdetail: postList
                                                                  .nameOfSchollar
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            titleStyle(
                                                              Htitle: "Program: ",
                                                              Hdetail: postList
                                                                  .programList
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
                                                                Hdetail:
                                                                "${postList.startDate} TO  ${postList.endDate}"),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            titleStyle(
                                                              Htitle: "Time: ",
                                                              Hdetail: postList.time
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            titleStyle(
                                                              Htitle: "Azakhana: ",
                                                              Hdetail: postList
                                                                  .azakhanaName
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
                                                                  .cityName
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                ExpansionTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(5.0),
                                                        padding: EdgeInsets.all(5.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                10),
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
                                                      child: Text(
                                                        postList.description
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontStyle:
                                                            FontStyle.italic,
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
                                                          decoration: TextDecoration
                                                              .underline),
                                                    ),
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
                                                      child: Text(
                                                        postList.specialNotes
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontStyle:
                                                            FontStyle.italic,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
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
                                                            postList.userName
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
                                                              postList.postDateTime
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
                                      //snapshot.data!.data!.addAll(snapshot.data!.data!.toList());
                                    });
                                    await Future.delayed(Duration(milliseconds: 1000));
                                    refreshController.loadComplete();
                                  }

                                },

                              );
                            }else if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else if (snapshot.hasError) {
                              return Center(
                                child: Text("Some thing went wrong !"),
                              );
                            }
                            else {
                              return Center(
                                child: Text("Some thing went wrong"),
                              );
                            }
                          },
                        )),
                  ],
                ),
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
          ),
        ),
      ),
    );
  }

  //***********************NOTIFICATION METHODS*********************

  //register notification
  void registerNotification() async{
    await Firebase.initializeApp();
    //instance for firebase messaging
    _messaging = FirebaseMessaging.instance;

    //Notification permission from user
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    //check user granted permission or not
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("user granted the permission");

      //our main message
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //saving the message in our put notification
        pushNotification notification = pushNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body']
        );
        setState(() {
          _totoalNotificatinCounter++;
          _notificationInfo = notification;
        });
        if(notification !=null){
          showSimpleNotification(
              Text(_notificationInfo!.title.toString()),
              leading: NotificationBadge(totalNotifiation: _totoalNotificatinCounter),
              subtitle: Text(_notificationInfo!.body.toString()),
              background: Colors.cyan.shade700,
              duration: Duration(seconds: 3)
          );
        }
      });
    }else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print("user granted the permission");
    }
    else{
      print("permission decline");
    }

    //getting token
    getToken();
    backgroundNotification();
    //when app is terminate
    checkForInitialMessage();
    subscribeTopic();

  }


  void backgroundNotification(){
    //when app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      pushNotification notification = pushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body']
      );

      setState(() {
        _totoalNotificatinCounter++;
        _notificationInfo = notification;
      });


    });
  }

  void getToken() async{
    //check for token
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var saveToken1 = sharedPreferences.getBool('saveToken');

    if (saveToken1 == null){

      await FirebaseMessaging.instance.getToken().then(
              (token){
            print("token : $token");

            //save current device token
            sharedPreferences.setString('userToken', token.toString());
          });
      //token saved or not??
      sharedPreferences.setBool('saveToken', true);

    }else{
      print("/////////token already saved");
      var getToken = sharedPreferences.get('userToken');
      print(getToken);
    }


  }


  //when app is terminate notificatin method
  checkForInitialMessage() async{
    await Firebase.initializeApp();
    RemoteMessage? initalMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initalMessage != null){

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        pushNotification notification = pushNotification(
            title: initalMessage.notification!.title,
            body: initalMessage.notification!.body,
            dataTitle: initalMessage.data['title'],
            dataBody: initalMessage.data['body']
        );

        setState(() {
          _totoalNotificatinCounter++;
          _notificationInfo = notification;
        });

      });

    }
  }



  //subscribed notification
  subscribeTopic() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var topic = sharedPreferences.getBool('isSubscribed');
    if(topic == null){
      await FirebaseMessaging.instance.subscribeToTopic("allNotification");
      sharedPreferences.setBool('isSubscribed', true);
    }else{
      print("already subscribed");
    }
  }



}

class ReusableDrawer extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback? onTap;

  const ReusableDrawer(
      {super.key,
        required this.title,
        required this.icon,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline),
        ),
        leading: icon,
        onTap: onTap,
        iconColor: Colors.white,
      ),
    );
  }
}

//Decoration title
class titleStyle extends StatelessWidget {
  final String Htitle;
  final String Hdetail;

  // ignore: non_constant_identifier_names
  const titleStyle({Key? key, required this.Htitle, required this.Hdetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
            text: Htitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              decoration: TextDecoration.underline,
              color: Colors.black,
              //color: Color(hexColors("004D40")),
              fontFamily: "Amiri",
            ),
            children: [
              TextSpan(
                text: Hdetail,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  //fontWeight: FontWeight.normal,
                ),
              )
            ]),
      ),
    );
  }
}
