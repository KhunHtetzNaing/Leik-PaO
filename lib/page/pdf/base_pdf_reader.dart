import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pao_library/model/book_model.dart';
import 'package:pao_library/utils/am2.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../controller/settings_controller.dart';
import '../../utils/constants.dart';

class BasePdfReader extends StatelessWidget {
  BasePdfReader({super.key, required this.item});
  final BookItem item;
  final PdfViewerController pdfViewerController = PdfViewerController();
  final SettingsController _settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  showSnack(String title, String message) {
    Get.snackbar(title, message,
        mainButton:
            TextButton(onPressed: () => Get.back(), child: Text("ok".tr)));
  }

  showPdfLoadError(String error, String description) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showErrorDialog("something_wrong".tr, "no_internet".tr);
    } else {
      showErrorDialog(error, description);
    }
  }

  loadFromNetwork(
      BuildContext context, RxBool isLoaded, OverlayEntry? overlayEntry) {
    debugPrint("load network");
    return SfPdfViewer.network(item.getSource,
        controller: pdfViewerController,
        pageLayoutMode: _settingsController.verticalPageLayoutMode.value ? PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
        canShowPaginationDialog: false,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          isLoaded.toggle();
          onLoaded(details);
        },
        onDocumentLoadFailed: onLoadFailed,
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && overlayEntry != null) {
            overlayEntry!.remove();
            overlayEntry = null;
          } else if (details.selectedText != null && overlayEntry == null) {
            overlayEntry = showContextMenu(context, details);
          }
        });
  }

  loadFromFile(
      BuildContext context, RxBool isLoaded, OverlayEntry? overlayEntry) {
    debugPrint("load network");
    return SfPdfViewer.file(item.file,
        controller: pdfViewerController,
        pageLayoutMode: _settingsController.verticalPageLayoutMode.value ? PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
        canShowPaginationDialog: false,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          isLoaded.toggle();
          onLoaded(details);
        },
        onDocumentLoadFailed: onLoadFailed,
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && overlayEntry != null) {
            overlayEntry!.remove();
            overlayEntry = null;
          } else if (details.selectedText != null && overlayEntry == null) {
            overlayEntry = showContextMenu(context, details);
          }
        });
  }

  OverlayEntry showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton.icon(
          onPressed: () {
            if (details.selectedText != null) {
              final uni = _settingsController.copyAsUnicode.value ? AM2.convert(details.selectedText!) : details.selectedText!;
              Constants.copy(uni);
              pdfViewerController.clearSelection();
            }
          },
          icon: const Icon(Icons.copy_rounded), label: Text('copy'.tr),
          
        ),
      ),
    );
    overlayState.insert(overlayEntry);
    return overlayEntry;
  }

  void onLoaded(PdfDocumentLoadedDetails details) {
    debugPrint("onDocumentLoaded: ${details.document.pages.count}");
  }

  void onLoadFailed(PdfDocumentLoadFailedDetails details) {
    showPdfLoadError(details.error, details.description);
  }

  /// Displays the error message.
  void showErrorDialog(String error, String description) {
    Get.dialog(AlertDialog(
      title: Text(error),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          child: Text('ok'.tr),
          onPressed: () => Get.back(),
        ),
      ],
    ));
  }

  void jumpToPage() {
    final TextEditingController textEditingController = TextEditingController();
    final hasError = "".obs;
    Get.dialog(AlertDialog(
      title: Text("go_to_page".tr),
      content: Obx(() => TextField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "enter_page_num_hint".tr,
                helperText:
                    "${pdfViewerController.pageNumber}/${pdfViewerController.pageCount}",
                errorText: hasError.isEmpty ? null : hasError.value),
          )),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("cancel".tr)),
        TextButton(
            onPressed: () {
              final number = Constants.extractNumber(
                  Constants.my2En(textEditingController.text));
              hasError.value = validate(number, pdfViewerController.pageCount);
              if (hasError.isEmpty) {
                pdfViewerController.jumpToPage(int.parse(number));
                Get.back();
              }
            },
            child: Text("ok".tr)),
      ],
    ));
  }

  String validate(String number, int max) {
    if (number.isEmpty) {
      return 'enter_valid_num'.tr;
    }

    if (int.parse(number) > max) {
      return "over_max_page".trParams({"size": max.toString()});
    }

    return "";
  }
}
