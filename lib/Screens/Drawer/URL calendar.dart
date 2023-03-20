import 'package:flutter/material.dart';
import 'package:mahuva_azadari/Models/Round%20Button.dart';
import 'package:mahuva_azadari/Screens/Drawer/PDF%20Calender.dart';
import '../../Models/Hexa color.dart';
import 'package:url_launcher/url_launcher.dart';


class URLCalender extends StatefulWidget {
  const URLCalender({Key? key}) : super(key: key);

  @override
  State<URLCalender> createState() => _URLCalenderState();
}

class _URLCalenderState extends State<URLCalender> {
  //https://ksijamat.org/calendar

  final Uri _url = Uri.parse('https://imam-us.org/imam-hijri-calendar');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(hexColors('006064')),
            title: Text(
              "Calender",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                //color: Colors.black
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundButton(title: 'Load Calender',
                    onPress: () {
                    _launchUrl();
                    },),
                  SizedBox(height: 20,),
                  RoundButton(title: 'PDF Bhavnagar Calendar',
                    onPress: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> Calender()));
                    },),
                ],
              ),
            ),
          ),

        )
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }


}
