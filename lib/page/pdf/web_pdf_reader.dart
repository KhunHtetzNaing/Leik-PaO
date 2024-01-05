import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pao_library/page/pdf/base_pdf_reader.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPdfReader extends BasePdfReader {
  WebPdfReader({super.key, required super.item});
  @override
  Widget build(BuildContext context) {
    var isLoaded = false.obs;
    OverlayEntry? overlayEntry;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name, maxLines: 1),
        actions: [
          Obx(() => IconButton(
              onPressed: isLoaded.isFalse ? null : () => jumpToPage(),
              icon: const Icon(Icons.import_contacts_rounded))),
          IconButton(
              onPressed: () => launchUrl(Uri.parse(item.getSource)),
              icon: const Icon(Icons.file_download_rounded)),
        ],
      ),
      body: loadFromNetwork(context, isLoaded, overlayEntry),
    );
  }
}
