import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pao_library/controller/settings_controller.dart';
import 'package:pao_library/lang/translation_service.dart';
import 'package:pao_library/page/downloads_page.dart';
import 'package:pao_library/page/home_page.dart';
import 'package:pao_library/page/settings_page.dart';
import 'package:pao_library/theme/theme.dart';
import 'controller/download_controller.dart';

void main() async {
  await GetStorage.init();
  await favoriteStorage.initStorage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());

    return GetMaterialApp(
      translations: TranslationService(), // your translations
      locale: settingsController.currentLanguage.locale, // translations will be displayed in that locale
      fallbackLocale: SettingsController.eng.locale, // specify the fallback locale in case an invalid locale is selected.
      title: 'app_name'.tr,
      theme: myTheme(settingsController.isDarkMode.value, settingsController.fontFamily),
      darkTheme: myTheme(true, settingsController.fontFamily),
      themeMode: settingsController.themeMode,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (index) => controller.changeIndex(index),
        destinations: _getBottomNavItem(),
      )),
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: _getPages(),
      )),
    );
  }
}

List<Widget> _getPages(){
  final List<Widget> items = [HomePage()];
  if(!kIsWeb){
    items.add(DownloadsPage());
  }
  items.add(const SettingsPage());
  return items;
}

List<Widget> _getBottomNavItem(){
  final List<Widget> items = [NavigationDestination(icon: const Icon(Icons.home_rounded), label: "home".tr)];
  if(!kIsWeb){
    items.add(NavigationDestination(icon: const Icon(Icons.download_rounded), label: "downloads".tr));
  }
  items.add(NavigationDestination(icon: const Icon(Icons.settings_rounded), label: "settings".tr));
  return items;
}

class MainController extends GetxController{
  var selectedIndex = 0.obs;

  void changeIndex(int index){
    selectedIndex.value = index;
  }
}