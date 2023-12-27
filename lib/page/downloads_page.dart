import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pao_library/controller/download_controller.dart';
import 'package:pao_library/model/book_model.dart';
import 'package:pao_library/page/pdf/pdf_reader.dart';
import 'package:pao_library/utils/dimen.dart';
import 'package:share_plus/share_plus.dart';

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
                          subtitle: Text(item.fileSize),
                          leading: const Icon(Icons.picture_as_pdf_rounded),
                          trailing: IconButton(
                              onPressed: () {
                                _action(item);
                              },
                              icon: const Icon(Icons.more_horiz_rounded)),
                          onTap: () {
                            Get.to(() => PdfReader(item: item));
                          },
                        ))
                    .toList(),
              )));
  }

  _action(BookItem item){
    Get.bottomSheet(BottomSheet(
        enableDrag: false,
        showDragHandle: false,
        onClosing: () {},
        builder: (builder) {
          return ListView(
            shrinkWrap: true,
            children: [
              const Padding(padding: EdgeInsets.only(top: Dimen.paddingLarge)),
              ListTile(
                  title: Text(item.fileName),
                  leading: const Icon(Icons.picture_as_pdf_rounded)),
              const Divider(),

              ListTile(
                title: Text("open_with".tr),
                leading: const Icon(Icons.open_with_rounded),
                onTap: () async {
                  Get.back();
                  final result =
                  await OpenFilex.open(
                      item.file.path);
                  if (result.type !=
                      ResultType.done) {
                    Get.snackbar(
                        item.name, result.message);
                  }
                },
              ),

              ListTile(
                title: Text("share".tr),
                leading: const Icon(Icons.share_rounded),
                onTap: () async {
                  Get.back();
                  Share.shareXFiles([
                    XFile(item.file.path,
                        mimeType: "application/pdf",
                        name: item.name)
                  ]);
                },
              ),
              ListTile(
                  title: Text("delete".tr),
                  leading: const Icon(Icons.delete_outline_rounded),
                  onTap: () async {
                    Get.back();

                    controller.delete(item).then((value) {
                      if(value){
                        controller.items.remove(item);
                        Get.snackbar(
                            item.name,
                            "has_been_deleted".tr,
                            mainButton: TextButton(onPressed: ()=> Get.back(), child: Text("ok".tr)),
                            snackPosition: SnackPosition.BOTTOM
                        );
                      }else{
                        showErrorDialog("something_wrong".tr, "unable_delete".trParams({"name": item.name}));
                      }
                    }
                    ).catchError((onError){
                      showErrorDialog("something_wrong".tr, onError.toString());
                    });
                  },
              )
            ],
          );
        }));
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
