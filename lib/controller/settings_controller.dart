import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pao_library/theme/theme.dart';

class LangModel{
  final String name;
  final Locale locale;
  LangModel({required this.name, required this.locale});

  String get fullName => name.tr;
}

class SettingsController extends GetxController{
  static LangModel pao = LangModel(name: "pao", locale: const Locale("pao","BLK"));
  static LangModel eng = LangModel(name: "english", locale: const Locale("en","US"));

  final _box = GetStorage();

  // Language
  final langKey = "lang";
  LangModel get currentLanguage => _box.read(langKey) == "en" ? eng : pao;
  void changeLanguage(LangModel model){
    _box.write(langKey, model.locale.languageCode);
    Get.updateLocale(model.locale);
  }

  // Embed
  String? get fontFamily => isEmbed.isTrue ? "Pyidaungsu" : null;
  final _embedFontKey = "embed";
  bool get _isEmbed {
    return _box.read(_embedFontKey) ?? false;
  }

  late var isEmbed = _isEmbed.obs;

  void toggleEmbedFont(bool val){
    _box.write(_embedFontKey, val);
    isEmbed.value = val;

    _updateTheme();
    Get.updateLocale(currentLanguage.locale);
  }

  void _updateTheme(){
    Get.changeTheme(myTheme(isDarkMode.value, fontFamily));
  }

  // Theme
  ThemeMode get themeMode => isDarkMode.isTrue ? ThemeMode.dark : ThemeMode.light;
  final _key = "dark_mode";
  bool get _isDarkMode {
    if(!_box.hasData(_key)){
      return Get.isDarkMode;
    }

    return _box.read(_key);
  }

  late var isDarkMode = _isDarkMode.obs;

  void toggleTheme() {
    isDarkMode.toggle();
    _box.write(_key, isDarkMode.value);

    _updateTheme();
    Get.updateLocale(currentLanguage.locale);
    //Get.changeThemeMode(themeMode);
  }
}