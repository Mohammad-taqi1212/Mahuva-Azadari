import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  //also take total notification value
  final int totalNotifiation;
   NotificationBadge({Key? key,required this.totalNotifiation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.pink,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(padding: EdgeInsets.all(8),
          child: Text(totalNotifiation.toString(),
          style: TextStyle(color: Colors.white,
          fontSize: 20),),
        ),
      ),
    );
  }
}
