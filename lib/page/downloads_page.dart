import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pao_library/controller/download_controller.dart';
import 'package:pao_library/page/pdf/pdf_reader.dart';

class DownloadsPage extends StatelessWidget {
  DownloadsPage({super.key});

  final DownloadController controller = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("downloads".tr),
        ),
        body: Obx(() => controller.items.isEmpty
            ? _showError("items_empty".tr)
            : ListView(
              children: controller.items
                  .map((item) => ListTile(
                title: Text(item.name),
                leading: const Icon(Icons.my_library_books_rounded),
                trailing: Text(item.fileSize),
                onTap: () {
                  Get.to(() => PdfReader(item: item));
                },
              ))
                  .toList(),
            )));
  }

  Widget _showError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
