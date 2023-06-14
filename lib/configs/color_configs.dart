import 'package:flutter/material.dart';

const int _primaryValue = 0xfffe67a4;
const MaterialColor primaryColor = MaterialColor(_primaryValue, <int, Color>{
  50: Color(0xffF8F7F7),
  100: Color(0xffFFE5F0),
  200: Color(0xFFFFB3D2),
  300: Color(0xffFE9FC5),
  400: Color(0xffFF86B7),
  500: Color(_primaryValue),
  600: Color(0xFFFE5F9C),
  700: Color(0xFFFE5492),
  800: Color(0xFFFE4A89),
  900: Color(0xFFFD3978),
});

const int _secondaryValue = 0xff5D60EF;
const MaterialColor secondaryColor =
    MaterialColor(_secondaryValue, <int, Color>{
  50: Color(0xFFECECFD),
  100: Color(0xFFCECFFA),
  200: Color(0xFFAEB0F7),
  300: Color(0xFF8E90F4),
  400: Color(0xFF7578F1),
  500: Color(_secondaryValue),
  600: Color(0xFF5558ED),
  700: Color(0xFF4B4EEB),
  800: Color(0xFF4144E8),
  900: Color(0xFF3033E4),
});

const int _greenValue = 0xffa5f1aa;
const MaterialColor greenColor = MaterialColor(_greenValue, <int, Color>{
  100: Color(0xffddfddf),
  500: Color(_greenValue),
  900: Color(0xff1EB640)
});

const int _orangeValue = 0xfff1c390;
const MaterialColor orangeColor = MaterialColor(_orangeValue, <int, Color>{
  100: Color(0xffffdfbc),
  500: Color(_orangeValue),
  900: Color(0xffFC9D36),
});

const int _purpleValue = 0xffacacff;
const MaterialColor purpleColor = MaterialColor(_purpleValue, <int, Color>{
  100: Color(0xffD4D4FC),
  500: Color(_purpleValue),
  900: Color(0xff8484FA)
});

const int _blueValue = 0xff59F4FF;
const MaterialColor blueColor = MaterialColor(_blueValue, <int, Color>{
  100: Color(0xffC7F7FB),
  500: Color(_blueValue),
  900: Color(0xff4B9ADF),
});

const int _redValue = 0xffD30B0B;
const MaterialColor redColor =
    MaterialColor(_redValue, <int, Color>{900: Color(_redValue)});
