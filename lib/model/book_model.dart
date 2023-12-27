import 'dart:io';

import 'package:pao_library/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BookItem {
  String name, src, thumb;
  List<String> categories;
  String? directory;
  int? index;

  BookItem({
    required this.name,
    required this.thumb,
    required this.src,
    required this.index,
    required this.categories,
    required this.directory,
  });

  String get fileName => "$name.pdf";

  String get id => name.hashCode.toString();

  File get file {
    if(directory != null) {
      return File(p.join(directory!,fileName));
    }
    throw MissingPlatformDirectoryException;
  }

  String get getThumb => thumb.startsWith("http") ? thumb : Constants.baseUrl + thumb;

  String get getSource => src.startsWith("http") ? src : Constants.baseUrl + src;

  String get fileSize => Constants.calculateFileSize(file.lengthSync(), 2);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "thumb": thumb,
      "src": src,
      "cat": categories,
      "directory": directory,
    };
  }

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
        name: json["name"],
        thumb: json["thumb"],
        src: json["src"],
        index: json["index"],
        directory: json["directory"],
        categories: json["cat"].cast<String>()
    );
  }
}

class CategoryItem{
  final String name;
  final String length;

  CategoryItem({required this.name, required this.length});
}

class BookModel {
  final List<CategoryItem> categories;
  final List<BookItem> books;
  BookModel({required this.categories, required this.books});
}
