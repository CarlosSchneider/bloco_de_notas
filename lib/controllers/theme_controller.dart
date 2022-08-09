/* ======================================================================================
 * Arquivo de configuração dos themas aplicados ao aplicativo
 * Versão 1.0.0
 * 
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyThemeController extends GetxController {
  late SharedPreferences prefs;
  var isDark = false.obs;
  Map<String, ThemeMode> themeModes = {
    'light': ThemeMode.light,
    'dark': ThemeMode.dark,
  };

  static MyThemeController get to => Get.find();

  loadThemeMode() async {
    prefs = await SharedPreferences.getInstance();
    String themeText = prefs.getString('theme') ?? 'light';
    isDark.value = themeText == 'dark' ? true : false;
    setMode(themeText);
  }

  Future setMode(String themeText) async {
    ThemeMode themeMode = themeModes[themeText] ?? ThemeMode.light;
    Get.changeThemeMode(themeMode);
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeText);
  }

  Icon get icon {
    return isDark.value ? const Icon(Icons.brightness_5) : const Icon(Icons.brightness_2);
  }

  String get label {
    return isDark.value ? 'dark' : 'light';
  }

  changeTheme() {
    setMode(isDark.value ? 'light' : 'dark');
    isDark.value = !isDark.value;
  }
}

// Classe com a definição das cores para os temas claros e escuros
class AppTheme {
  // Construtor "oculto"
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    bottomAppBarColor: Colors.teal.shade800,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.teal.shade200,
    appBarTheme: AppBarTheme(
      color: Colors.teal.shade600,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light),
    cardTheme: CardTheme(elevation: 6, color: Colors.teal.shade300),
    iconTheme: const IconThemeData(color: Colors.white54),
    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.black, fontSize: 24.0),
      headline2: TextStyle(color: Colors.black87, fontSize: 24.0),
      headline3: TextStyle(color: Colors.black, fontSize: 22.0),
      headline4: TextStyle(color: Colors.black87, fontSize: 22.0),
      headline5: TextStyle(color: Colors.black, fontSize: 20.0),
      headline6: TextStyle(color: Colors.black87, fontSize: 20.0),
      subtitle1: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(color: Colors.black87, fontSize: 18.0),
      bodyText1: TextStyle(color: Colors.black87, fontSize: 18.0),
      bodyText2: TextStyle(color: Colors.black, fontSize: 16.0),
      caption: TextStyle(color: Colors.black87, fontSize: 18.0),
      button: TextStyle(color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.teal.shade800),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: darkPrimarySwatch,
    bottomAppBarColor: darkPrimarySwatch.shade600,
    scaffoldBackgroundColor: darkPrimarySwatch.shade700,
    appBarTheme: AppBarTheme(
      color: darkPrimarySwatch.shade500,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: darkPrimarySwatch, brightness: Brightness.dark),
    cardTheme: CardTheme(elevation: 6, color: darkPrimarySwatch.shade400),
    iconTheme: const IconThemeData(color: Colors.white54),
    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.white, fontSize: 24.0),
      headline2: TextStyle(color: Colors.white70, fontSize: 24.0),
      headline3: TextStyle(color: Colors.white, fontSize: 22.0),
      headline4: TextStyle(color: Colors.white70, fontSize: 22.0),
      headline5: TextStyle(color: Colors.white, fontSize: 20.0),
      headline6: TextStyle(color: Colors.white70, fontSize: 20.0),
      subtitle1: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(color: Colors.white70, fontSize: 18.0),
      bodyText1: TextStyle(color: Colors.white70, fontSize: 18.0),
      bodyText2: TextStyle(color: Colors.white, fontSize: 16.0),
      caption: TextStyle(color: Colors.white70, fontSize: 18.0),
      button: TextStyle(color: Colors.white70, fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: darkPrimarySwatch.shade400, foregroundColor: Colors.white),
  );

  static const backgroundAlert = Color.fromARGB(185, 243, 229, 33);
  static const backgroundSuccess = Color.fromARGB(185, 76, 175, 79);
  static const backgroundCaution = Color.fromARGB(185, 243, 65, 33);
  static const foregroundText = Colors.black;

  static const darkPrimarySwatch = MaterialColor(
    0xFF002219,
    <int, Color>{
      50: Color(0xFF00796B),
      100: Color(0xFF00695C),
      200: Color(0xFF005850),
      300: Color(0xFF004D40),
      400: Color(0xFF004030),
      500: Color(0xFF002219),
      600: Color(0xFF002017),
      700: Color(0xFF001512),
      800: Color(0xFF001007),
      900: Color(0xFF000502),
    },
  );
}
