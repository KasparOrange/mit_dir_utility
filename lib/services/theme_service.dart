import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';


class ThemeService with ChangeNotifier {
  var themeMode = ThemeMode.light;
  var lightenColors = true;

  void toggleThemeMode() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    lightenColors = themeMode == ThemeMode.light;
    notifyListeners();
  }

  final primaryColor = const Color(0xFF3D6B4F);
  final secondaryColor = const Color(0xFF6a1e03);

  // final scheme1 = CustomColorScheme(
  //     primaryColor: const Color(0xFF3D6B4F),
  //     secondaryColor: const Color(0xFF6a1e03),
  //     tertiaryColor: Colors.black);

  // final scheme2 = CustomColorScheme(
  //     primaryColor: const Color(0xFF3d6b4f),
  //     secondaryColor: const Color(0xFF6b4d3d),
  //     tertiaryColor: const Color(0xFF6b3d4b));

  // bool get lightenColors => themeMode == ThemeMode.light;

  late final textButtonThemeData = TextButtonThemeData(
      style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size.fromWidth(100)),
          overlayColor: MaterialStatePropertyAll(primaryColor.getShadeColor(
              shadeValue: 10, lighten: lightenColors)),
          iconColor: MaterialStatePropertyAll(primaryColor.getShadeColor(
              shadeValue: 50, lighten: lightenColors))));

  late final scheme1 = ColorScheme.fromSeed(
    seedColor: Colors.black,
    primary: const Color(0xFF3D6B4F),
    secondary: const Color(0xFF6a1e03),
    tertiary: Colors.black,
  );

  late final scheme2 = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3D6B4F),
      primary: const Color(0xFF3D6B4F),
      secondary: const Color(0xFF6a1e03),
      tertiary: const Color(0xFF6b3d4b));

  late final scheme4 = ColorScheme(
    primary: primaryColor, 
    onPrimary: Colors.black, 
    secondary: secondaryColor, 
    onSecondary: primaryColor.getShadeColor(shadeValue: 10, lighten: true), 
    background: primaryColor.getShadeColor(shadeValue: 60, lighten: true), 
    onBackground: Colors.black, 
    surface: primaryColor.getShadeColor(shadeValue: 10, lighten: true),
    onSurface: primaryColor.getShadeColor(shadeValue: 20, lighten: true), 
    error: Colors.red, 
    onError: Colors.red.getShadeColor(shadeValue: 20, lighten: false), 
    brightness: Brightness.light, 
  );
    

  // late final scheme3 =
  //     ColorScheme.fromSeed(seedColor: primaryColor, secondary: secondaryColor);

  late final lightTheme = ThemeData(
    dividerColor: Colors.black,
    colorScheme: scheme4,
    textButtonTheme: textButtonThemeData,
  );

  late final darkTheme =
      ThemeData.dark().copyWith(textButtonTheme: textButtonThemeData);

  // flex_color_scheme
  // late final lightTheme = FlexThemeData.light(scheme: FlexScheme.dellGenoa);
  // late final darkTheme = FlexThemeData.dark(scheme: FlexScheme.dellGenoa);
}

// class CustomColorScheme {
//   CustomColorScheme(
//       {required this.primaryColor,
//       required this.secondaryColor,
//       required this.tertiaryColor});
//   Color primaryColor;
//   Color secondaryColor;
//   Color tertiaryColor;
//   ColorScheme toColorSchmeFromSeed() {
//     return ColorScheme.fromSeed(
//         seedColor: primaryColor,
//         secondary: secondaryColor,
//         tertiary: tertiaryColor);
//   }
// }