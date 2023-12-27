import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("language".tr),
            leading: const Icon(Icons.language_rounded),
            subtitle: Text(settingsController.currentLanguage.fullName),
            onTap: () => _showLanguageDialog(context, settingsController),
          ),
          Obx(() => SwitchListTile(
              title: Text("embed_font".tr),
              secondary: const Icon(Icons.font_download_rounded),
              subtitle: Text("use_pyidaungsu".tr),
              value: settingsController.isEmbed.value,
              onChanged: (checked) {
                settingsController.toggleEmbedFont(checked);
              }
          ))
          ,
          ListTile(
            title: Text("current_version".tr),
            leading: const Icon(Icons.history_rounded),
            subtitle: Text("current_version_note".tr),
            onTap: (){
              launchUrl(Uri.parse("https://github.com/KhunHtetzNaing/Leik-PaO"));
            },
          ),
          ListTile(
            title: Text("developer".tr),
            leading: const Icon(Icons.code_rounded),
            subtitle: Text("khun_htetz_naing".tr),
            onTap: () {
              launchUrl(Uri.parse("https://www.facebook.com/iamHtetz"));
            },
          ),
          ListTile(
            title: Text("translator".tr),
            leading: const Icon(Icons.translate_rounded),
            subtitle: Text("khun_moung".tr),
            onTap: () {
              launchUrl(Uri.parse("https://www.facebook.com/khun.zawoohopone.5"));
            },
          )
        ],
      ),
    );
  }

  _showLanguageDialog(
      BuildContext context, SettingsController settingsController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_language'.tr),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [SettingsController.eng, SettingsController.pao].map((item) => ListTile(
                title: Text(item.fullName),
                onTap: () {
                  settingsController.changeLanguage(item);
                  Get.back();
                },
              ))
                  .toList()),
        );
      },
    );
  }
}