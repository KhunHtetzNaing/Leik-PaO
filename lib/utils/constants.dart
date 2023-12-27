import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class Constants{
  static const baseUrl = "https://raw.githubusercontent.com/KhunHtetzNaing/PaO-Books/main/";
  static const dataUrl = "${baseUrl}data.json";
  static const homeIndex = 0;
  static const allIndex = 1;
  static final _en2My = {"0":"၀", "1":"၁", "2":"၂", "3":"၃", "4":"၄", "5":"၅", "6":"၆", "7":"၇", "8":"၈", "9":"၉"};
  static String en2my(String input) {
    return input
        .split("")
        .map((item) => _en2My[item] ?? item)
        .join();
  }

  static String my2En(String input) {
    final my2Eng = _en2My.map((key, value) => MapEntry(value, key));
    return input
        .split("")
        .map((item) => my2Eng[item] ?? item)
        .join();
  }

  static String extractNumber(String text){
    return text.replaceAll(RegExp(r'[^0-9]'),'');
  }

  static String calculateFileSize(int? fileSize, int decimals) {
    if (fileSize == null || fileSize <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(fileSize) / log(1024)).floor();
    return '${(fileSize / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static Future<Directory> get rootDirectory async => getApplicationDocumentsDirectory();

  static Future<Directory> get pdfDirectory async {
    final root = await rootDirectory;
    return Directory("${root.path}/PDF");
  }
}

