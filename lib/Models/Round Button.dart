import 'package:flutter/material.dart';

import 'Hexa color.dart';

class RoundButton extends StatelessWidget {
  final String title ;
  final VoidCallback onPress;

  RoundButton({required this.title,required this.onPress});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        //clipBehavior: Clip.antiAlias,
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(hexColors('0097A7')),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),),
        ),
        child: Text(title,
          style:
          TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Amiri',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic
          ),),
      ),
    );
  }
}

