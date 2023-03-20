import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahuva_azadari/Models/Hexa%20color.dart';
import 'package:mahuva_azadari/Screens/Drawer/Home.dart';
import 'package:mahuva_azadari/Screens/Drawer/fullscreenDemo.dart';
import 'package:overlay_support/overlay_support.dart';
import 'Screens/Admin Data/Add Live Programe.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(_required());

  //for globally describe status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(hexColors("006064")),
  ));
}
class _required extends StatefulWidget {
  const _required({Key? key}) : super(key: key);

  @override
  State<_required> createState() => _requiredState();
}

class _requiredState extends State<_required> {

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        //Custom font for entire app
        theme: ThemeData(
          fontFamily: "Amiri",
        ),

        //home: HomePage(),
        home: HomePage(),
      ),
    );
  }
}
