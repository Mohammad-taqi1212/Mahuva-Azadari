import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/Add%20Live%20Programe.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/AddMayyatNews.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/AddPost.dart';
import 'package:mahuva_azadari/Screens/Admin%20Data/Admin%20Links.dart';
import 'package:mahuva_azadari/Screens/Drawer/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Hexa color.dart';
import 'Admin M_News.dart';
import 'AdminPost.dart';

class AdminPannel extends StatefulWidget {
  const AdminPannel({Key? key}) : super(key: key);

  @override
  State<AdminPannel> createState() => _AdminPannelState();
}

class _AdminPannelState extends State<AdminPannel> {

  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(title: Text("Admin Pannel",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                //color: Colors.black
              ),
            ),

            //centerTitle: true,
              backgroundColor: Color(hexColors('006064')),
            leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
              bottom:const TabBar(
                tabs: [
                  Tab(
                    child:
                    Text("Post",
                      style: TextStyle(fontSize: 18),),
                  ),
                  Tab(
                    child:
                    Text("Y-Links",
                    style: TextStyle(fontSize: 18),),
                  ),
                  Tab(
                    child:
                    Text("M-News",
                      style: TextStyle(fontSize: 18),),
                  ),
                ],
              ),
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                          child: Text("Add Posts"),
                      ),
                      PopupMenuItem(
                          value: 1,
                          child: Text("Add Links"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Add M.News"),
                      ),
                      PopupMenuItem(
                          value: 3,
                          child: Text("Logout"),
                      ),
                    ],
                  onSelected: (value) async{
                    if(value == 0){
                     Navigator.push(context,
                         MaterialPageRoute(builder: (context) => AddPost()));
                    }else if (value == 1){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddLiveProgram()));
                    }else if (value == 2){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddMayyatNews()));
                    }
                    else{
                      _googleSignIn.signOut();
                      _googleSignIn.disconnect();
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      => HomePage()));
                      Fluttertoast.showToast(msg: "Successfully logout",
                          backgroundColor: Color(hexColors("006064"))
                      );
                    }
                  },
                ),
              ],
            ),
            body: TabBarView(
              children: [
                //Code for tab 1
                AdminPost(),
                AdminLinks(),
                AdminMnews(),
              ],
            ),
          ),
        )
    );
  }
}
