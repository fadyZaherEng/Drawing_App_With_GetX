import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
ThemeData darkTheme() => ThemeData(
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: HexColor('000028'),
    appBarTheme: AppBarTheme(
      backgroundColor: HexColor('00028'),
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        color: Colors.pink,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('000028'),
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: const IconThemeData(
        color: Colors.pink,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.pink,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0.0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      backgroundColor: HexColor('000028'),
      unselectedItemColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    textTheme:  TextTheme(
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: HexColor('000028')
      ),
      bodyText1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 15,
        color: Colors.white,
      ),
      caption: TextStyle(
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: HexColor('180040'),
    ),
    hintColor: Colors.white,
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    drawerTheme: DrawerThemeData(
      elevation: 0,
      backgroundColor: HexColor('000028'),
    ),
    bottomSheetTheme:
    BottomSheetThemeData(backgroundColor: HexColor('000028')));