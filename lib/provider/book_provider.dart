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
        final connectivityResult = await (Connectivity().checkConnectivity());
        if(connectivityResult == ConnectivityResult.none){
          return Future.error("no_internet".tr);
        }
        return Future.error('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.none){
        return Future.error("no_internet".tr);
      }
      return Future.error('Error fetching books: $e');
    }
  }

  Future<BookModel> _parseData(String body) async {
    final pdfDirectory = kIsWeb ? null : await Constants.pdfDirectory;

    final books = (jsonDecode(body) as List<dynamic>).map((e) {
      final item = BookItem.fromJson(e);
      // Get file name for directory
      if(!kIsWeb) {
        item.directory = Directory(p.join(pdfDirectory!.path, item.name)).path;
      }

      return item;
    }).toList();

    // Extract category and length
    Map<String,int> categoriesMap = {};
    for(var book in books){
      for(var category in book.categories){
        categoriesMap.update(category, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final categories = categoriesMap.entries.map((e) => CategoryItem(name: e.key, length: e.value.toString())).toList();

    categories.insert(Constants.homeIndex,CategoryItem(name: Constants.homeName, length: books.where((element) => element.index != null).length.toString()));
    categories.insert(Constants.allIndex,CategoryItem(name: Constants.allName, length: books.length.toString()));
    return BookModel(
        categories: categories,
        books: books
    );
  }
}