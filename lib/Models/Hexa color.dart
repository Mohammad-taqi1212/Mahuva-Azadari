import 'package:flutter/material.dart';

int hexColors(String c){
  String sColor = '0xff' + c;
  int dColor = int.parse(sColor);
  return dColor;
}