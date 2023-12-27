import 'package:get/get.dart';

import '../model/book_model.dart';
import 'download_controller.dart';

class PdfReaderController extends GetxController{
  final _storage = favoriteStorage;
  var isLocal = false.obs;

  isDownloaded(BookItem item) {
    final file = item.file;
    isLocal.value = file.existsSync() && _storage.hasData(item.id);
  }

  Future<bool> save(List<int> dataBytes, BookItem item) async {
    final file = item.file;
    final directory = file.parent;
    final isDirectoryExist = await directory.exists();
    if(!isDirectoryExist) await directory.create(recursive: true);

    await file.writeAsBytes(dataBytes);
    _storage.write(item.id, item);
    isDownloaded(item);
    return file.existsSync();
  }

  Future<bool> delete(BookItem item) async {
    final file = item.file;
    await file.delete();
    _storage.remove(item.id);
    isDownloaded(item);
    final exist = await file.exists();
    return !exist;
  }
}