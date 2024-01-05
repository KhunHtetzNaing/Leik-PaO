import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pao_library/page/pdf/base_pdf_reader.dart';
import '../../controller/download_controller.dart';
import '../../controller/pdf_reader_controller.dart';

class PdfReader extends BasePdfReader {
  PdfReader({super.key, required super.item});
  @override
  Widget build(BuildContext context) {
    final PdfReaderController readerController = Get.put(PdfReaderController());
    final DownloadController downloadController =
        Get.find<DownloadController>();
    readerController.isDownloaded(item);

    var isLoaded = false.obs;
    OverlayEntry? overlayEntry;

    return Scaffold(
        appBar: AppBar(
          title: Text(item.name, maxLines: 1),
          actions: [
            Obx(() => IconButton(
                onPressed: isLoaded.isFalse ? null : () => jumpToPage(),
                icon: const Icon(Icons.import_contacts_rounded))),
            Obx(() => readerController.isLocal.value
                ? IconButton(
                    onPressed: () async {
                      readerController.delete(item).then((value) {
                        if (value) {
                          downloadController.items.remove(item);
                          showSnack(item.name, "has_been_deleted".tr);
                        } else {
                          showErrorDialog("something_wrong".tr,
                              "unable_delete".trParams({"name": item.name}));
                        }
                      }).catchError((onError) {
                        showErrorDialog(
                            "something_wrong".tr, onError.toString());
                      });
                    },
                    icon: const Icon(Icons.delete_rounded))
                : IconButton(
                    onPressed: isLoaded.isFalse
                        ? null
                        : () async {
                            readerController
                                .savePdf(pdfViewerController, item)
                                .then((value) {
                              if (value) {
                                downloadController.items.add(item);
                                showSnack(item.name, "has_been_saved".tr);
                              } else {
                                showErrorDialog(
                                    "something_wrong".tr,
                                    "unable_save"
                                        .trParams({"name": item.name}));
                              }
                            }).catchError((onError) {
                              showErrorDialog(
                                  "something_wrong".tr, onError.toString());
                            });
                          },
                    icon: const Icon(Icons.file_download_rounded))),
          ],
        ),
        body: item.file.existsSync() ? loadFromFile(context, isLoaded, overlayEntry) : loadFromNetwork(context, isLoaded, overlayEntry));
  }
}
