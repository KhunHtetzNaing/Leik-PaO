import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pao_library/model/book_model.dart';

final favoriteStorage = GetStorage("favorite");
class DownloadController extends GetxController{
  RxList<BookItem> items = RxList.empty();

  final _storage = favoriteStorage;

  Iterable<BookItem> savedItems(){
    return List.from(_storage.getValues())
        .whereType<Map<String, dynamic>>()
        .map((e) => BookItem.fromJson(e)).where((e) => e.file.existsSync() == true);
  }

  @override
  void refresh() {
    items.value = savedItems().toList();
    super.refresh();
  }

  @override
  void onInit() {
    refresh();
    debugPrint("onInit: DownloadController");
    super.onInit();
  }
}