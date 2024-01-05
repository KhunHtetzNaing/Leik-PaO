import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pao_library/controller/settings_controller.dart';
import 'package:pao_library/model/book_model.dart';
import 'package:pao_library/page/pdf/pdf_reader.dart';
import 'package:pao_library/page/pdf/web_pdf_reader.dart';
import 'package:pao_library/utils/constants.dart';
import 'package:pao_library/utils/dimen.dart';
import '../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar(controller),
      body: controller.obx(
          (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_categories(controller), _bookList(data!)],
              ),
          onEmpty: _showError(controller, "items_empty".tr),
          onError: (error) => _showError(controller, error!)
      ),
    );
  }
}

Widget _showError(HomeController controller, String error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          error,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Dimen.paddingSmallest),
        ElevatedButton(onPressed: () {
          controller.fetchBook();
        }, child: Text("retry".tr))
      ],
    ),
  );
}

void openPDF(BookItem item) {
  // Get.to(PdfReader(name: item.name,pdfLink: item.src));
  Get.to(() => kIsWeb ? WebPdfReader(item: item) : PdfReader(item: item));
}

Widget _bookList(List<BookItem> data) {
  return Expanded(
      child: GridView.extent(
    childAspectRatio: 1 / 1.7,
    maxCrossAxisExtent: 200.0, // maximum item width
    mainAxisSpacing: Dimen.paddingSmall, // spacing between rows
    crossAxisSpacing: Dimen.paddingSmall, // spacing between columns
    padding: const EdgeInsets.symmetric(
        horizontal: Dimen.paddingMedium), // padding around the grid
    children: data.map((item) {
      return GestureDetector(
        onTap: () => openPDF(item),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: FadeInImage(
                placeholderFit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 500),
                fadeOutDuration: const Duration(milliseconds: 100),
                fit: BoxFit.fill,
                imageErrorBuilder: (context, obj, tract){
                  return const Image(image: AssetImage("images/placeholder.png"));
                },
                placeholder: const AssetImage("images/placeholder.png"),
                image: NetworkImage(item.getThumb),
              ),
            ),
            const SizedBox(
              height: Dimen.paddingSmallest,
            ),
            Center(child: Text(item.name))
          ],
        ),
      );
    }).toList(),
  ));
}

Widget _categories(HomeController controller) {
  return SizedBox(
    height: kToolbarHeight + Dimen.paddingSmallest,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimen.paddingSmall,
          ),
          child: Obx(() => Badge(
                // backgroundColor: Theme.of(context).colorScheme.primary,
                label:
                    Text(controller.categories[index].length),
                child: ChoiceChip(
                  label: Text(controller.categories[index].name),
                  onSelected: (selected) {
                    if (selected) {
                      controller.selectCategory(index);
                    }
                  },
                  selected: controller.selectedCategory.value == index,
                ),
              )),
        );
      },
    ),
  );
}

AppBar _myAppBar(HomeController homeController) {
  return AppBar(
    scrolledUnderElevation: 0,
    toolbarHeight: kToolbarHeight + Dimen.paddingMedium,
    flexibleSpace: _searchBar(homeController),
  );
}

Widget _searchBar(HomeController homeController) {
  final SettingsController settingsController = Get.find<SettingsController>();
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimen.paddingMedium, vertical: Dimen.paddingSmall),
      child: SearchAnchor(
        viewHintText: "search".tr,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
              controller: controller,
              // padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: Dimen.paddingMedium)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              hintText: "search".tr,
              leading: IconButton(
                onPressed: () => controller.openView(),
                icon: const Icon(Icons.search),
              ),
              trailing: <Widget>[
                Obx(() =>
              IconButton(
                      tooltip: 'change_appearance'.tr,
                      icon: const Icon(Icons.wb_sunny_outlined),
                      selectedIcon: const Icon(Icons.brightness_2_outlined),
                      isSelected: settingsController.isDarkMode.value,
                      onPressed: () => settingsController.toggleTheme(),
                    )
                )
              ]);
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          Iterable<BookItem> getFilteredItems(String query) {
            if (query.isEmpty) {
              return [];
            }

            final myanmarQuery = Constants.en2my(query);

            return homeController.books.where((item) => item.name.contains(myanmarQuery));
          }

          Iterable<Widget> buildFilteredItemTiles(Iterable<BookItem> items) {
            return items.map((item) => ListTile(
                  title: Text(item.name),
                  onTap: () {
                    // controller.closeView(item.name);
                    openPDF(item);
                  },
                ));
          }

          Iterable<BookItem> filteredItems = getFilteredItems(controller.text);
          return buildFilteredItemTiles(filteredItems);
        },
      ),
    ),
  );
}
