import 'package:flutter/material.dart';

import 'color_schemes.g.dart';

myTheme(bool isDarkMode, String? fontFamily){
  return ThemeData(
      useMaterial3: true,
      colorScheme: isDarkMode ? darkColorScheme : lightColorScheme,
      fontFamily: fontFamily
  );
}