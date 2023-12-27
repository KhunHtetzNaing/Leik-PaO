import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pao_library/model/book_model.dart';
import 'package:path/path.dart' as p;
import '../utils/constants.dart';

final favoriteStorage = GetStorage("favorite");
class DownloadController extends GetxController{
  RxList<BookItem> items = RxList.empty();

  final _storage = favoriteStorage;

  _loadSavedItem() async {
    final pdfDirectory = kIsWeb ? null : await Constants.pdfDirectory;
    final list =  List.from(_storage.getValues())
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final item = BookItem.fromJson(e);
          // Get file name for directory
          if(!kIsWeb) {
            item.directory = Directory(p.join(pdfDirectory!.path, item.name)).path;
          }
          return item;
        }).where((e) => e.file.existsSync() == true);

    items.value = list.toList();
  }

  Future<bool> delete(BookItem item) async {
    final file = item.file;
    await file.delete();
    _storage.remove(item.id);
    final exist = await file.exists();
    return !exist;
  }

  @override
  void refresh() {
    _loadSavedItem();
    super.refresh();
  }

  @override
  void onInit() {
    refresh();
    super.onInit();
  }
}