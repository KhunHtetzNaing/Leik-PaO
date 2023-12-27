import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pao_library/model/book_model.dart';
import 'package:pao_library/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class BookProvider extends GetConnect{

  Future<BookModel> getBooks() async {
    try {
      final response = await http.get(Uri.parse(Constants.dataUrl));
      if (response.statusCode == HttpStatus.ok) {
        return _parseData(response.body);
      }else{
        return Future.error('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return Future.error('Error fetching books: $e');
    }
  }

  Future<BookModel> _parseData(String body) async {
    final pdfDirectory = kIsWeb ? null : await Constants.pdfDirectory;

    final books = (jsonDecode(body) as List<dynamic>).map((e) {
      // Get file name for directory
      if(!kIsWeb) {
        final name = e["name"] as String;
        e["directory"] = Directory(p.join(pdfDirectory!.path, name)).path;
      }

      return BookItem.fromJson(e);
    }).toList();

    // Extract category and length
    Map<String,int> categoriesMap = {};
    for(var book in books){
      for(var category in book.categories){
        categoriesMap.update(category, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final categories = categoriesMap.entries.map((e) => CategoryItem(name: e.key, length: e.value.toString())).toList();

    categories.insert(Constants.homeIndex,CategoryItem(name: "home".tr, length: books.where((element) => element.index != null).length.toString()));
    categories.insert(Constants.allIndex,CategoryItem(name: "all".tr, length: books.length.toString()));
    return BookModel(
        categories: categories,
        books: books
    );
  }
}