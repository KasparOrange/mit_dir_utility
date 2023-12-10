
import 'package:flutter/material.dart';

class ThemeService {
  static final CustomColors colors = CustomColors();

  static final ThemeData mainTheme = ThemeData(
    colorScheme: mainColorScheme.copyWith(brightness: Brightness.light),

    textTheme: const TextTheme(
      // labelLarge: TextStyle(fontSize: 20.0, fontFamily: 'Willow'), // That is used for material buttons
      labelMedium: TextStyle(fontSize: 16.0, fontFamily: 'Willow'),
      labelSmall: TextStyle(fontSize: 12.0, fontFamily: 'Willow'),
      displayLarge: TextStyle(fontSize: 34.0, fontFamily: 'Willow'),
      displayMedium: TextStyle(fontSize: 20.0, fontFamily: 'Willow'),
      displaySmall: TextStyle(fontSize: 16.0, fontFamily: 'Willow'),
      // bodyLarge: TextStyle(fontSize: 20.0, fontFamily: 'Willow'),
      bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Arial'),
    ),

    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 24,
    ),

    inputDecorationTheme: InputDecorationTheme(
      suffixIconColor: Colors.black,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: colors.tertiary,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: colors.tertiary,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: colors.secondary,
          width: 3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: colors.error,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: colors.error,
          width: 2,
        ),
      ),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontFamily: 'Willow',
        letterSpacing: 1.5,
      ),
      hintStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Arial',
      ),
      helperStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Arial',
      ),
      errorStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Arial',
      ),
      // iconColor: colors.secondary,
    ),

    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: colors.niceOrage,
    //     // foregroundColor: Colors.black,
    //   ),
    // ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        side: const BorderSide(),
        backgroundColor: colors.secondary,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        textStyle: const TextStyle(
          fontSize: 26.0,
          fontFamily: 'Willow',
        ),
        foregroundColor: Colors.black,
      ),
    ),
    brightness: Brightness.light,
    useMaterial3: false,
  );

  static final ColorScheme mainColorScheme = ColorScheme.fromSeed(seedColor: colors.background);

  // var themeMode = ThemeMode.light;
  // var lightenColors = true;

  // void toggleThemeMode() {
  //   themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  //   lightenColors = themeMode == ThemeMode.light;
  //   notifyListeners();
  // }
}
// transform this class into a map where the key is the name of the color and the value is the color

class CustomColors {
  final Color highlight = const Color.fromARGB(255, 226, 152, 67);
  final Color error = const Color.fromARGB(255, 223, 56, 23);
  final Color errorLight = const Color.fromARGB(255, 185, 33, 3);
  final Color errorDark = const Color.fromARGB(255, 148, 26, 2);
  final Color ok = const Color.fromARGB(255, 124, 197, 35);
  final Color okLight = const Color.fromARGB(255, 155, 185, 3);
  final Color okDark = const Color.fromARGB(255, 124, 148, 2);

  final Color niceOrage = const Color.fromARGB(255, 254, 134, 0);

  final Color secondary = const Color.fromARGB(255, 69, 91, 120);
  final Color tertiary = const Color.fromARGB(255, 45, 48, 55);

  final Color background = const Color(0xff92683E);
  final Color oldBackground = const Color.fromARGB(255, 129, 85, 0);
  final Color newBackground = const Color(0xff8b5000);

  final Color oldPrimaryColor = const Color.fromARGB(255, 185, 124, 3);
  final Color oldSecondaryColor = const Color.fromARGB(255, 129, 85, 0);
  final Color oldTertiaryColor = const Color.fromARGB(255, 245, 221, 166);

  final Color paynesGray = const Color.fromARGB(255, 87, 110, 135);
  final Color linen = const Color.fromARGB(255, 253, 245, 234);
  final Color delftBlue = const Color.fromARGB(255, 50, 58, 79);
  final Color davysGray = const Color.fromARGB(255, 72, 73, 86);
  final Color butterscotch = const Color.fromARGB(255, 229, 150, 57);

  Map<String, Color> get map => {
        'highlight': highlight,
        'error': error,
        'errorLight': errorLight,
        'errorDark': errorDark,
        'ok': ok,
        'okLight': okLight,
        'okDark': okDark,
        'niceOrage': niceOrage,
        'secondary': secondary,
        'tertiary': tertiary,
        'background': background,
        'oldPrimaryColor': oldPrimaryColor,
        'oldSecondaryColor': oldSecondaryColor,
        'oldTertiaryColor': oldTertiaryColor,
        'Payne\'s gray': paynesGray,
        'Linen': linen,
        'Delft Blue': delftBlue,
        'Davy\'s gray': davysGray,
        'Butterscotch': butterscotch,
      };
}
