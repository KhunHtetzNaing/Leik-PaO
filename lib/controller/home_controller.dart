import 'package:get/get.dart';
import 'package:pao_library/model/book_model.dart';
import 'package:pao_library/provider/book_provider.dart';
import 'package:pao_library/utils/constants.dart';

class HomeController extends GetxController with StateMixin<List<BookItem>>{
  var selectedCategory = 0.obs;
  final BookProvider _bookProvider = BookProvider();
  List<BookItem> books = [];
  List<CategoryItem> categories = [];

  void selectCategory(int index){
    selectedCategory.value = index;
    _updateItem(_filter(index));
  }

  List<BookItem> _filter(int index){
    final category = categories[index];
    List<BookItem> selected = [];
    if(index == Constants.homeIndex){
      selected.addAll(books.where((element) => element.index != null));
      selected.sort((a,b) => a.index!.compareTo(b.index!));
    }else if(index == Constants.allIndex){
      selected.addAll(books);
    }else{
      selected.addAll(books.where((element) => element.categories.contains(category.name)));
    }
    return selected;
  }

  void _updateItem(List<BookItem> items){
    if(items.isEmpty){
      change(null, status: RxStatus.empty());
    }else{
      change(items, status: RxStatus.success());
    }
  }

  void fetchBook(){
    change(null,status: RxStatus.loading());
    _bookProvider.getBooks().then((response) {
      books = response.books;
      categories = response.categories;
      _updateItem(_filter(Constants.homeIndex));
    },onError: (error){
      change(List.empty(),status: RxStatus.error(error.toString()));
    });
  }

  @override
  void onInit() {
    fetchBook();
    super.onInit();
  }
}