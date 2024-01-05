import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:pao_library/utils/am2.dart';
import 'package:pao_library/utils/dimen.dart';
import 'package:pao_library/utils/rabbit.dart';
import '../utils/constants.dart';

// DropdownMenuEntry labels and values for the second dropdown menu.
enum ConvertItem {
  ascii('ASCII'),
  zawgyi('Zawgyi'),
  unicode('Unicode');

  const ConvertItem(this.label);
  final String label;
}

class ConverterPage extends StatelessWidget {
  ConverterPage({super.key});

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConvertItem convertFrom = ConvertItem.ascii;
    ConvertItem convertTo = ConvertItem.unicode;
    var isError = "".obs;

    return Scaffold(
      appBar: AppBar(
          title: AutoSizeText(
            "font_converter".tr,
            style: Theme.of(context).textTheme.titleLarge,
            minFontSize: 18,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
      ),
        actions: [
          IconButton(onPressed: () async {
            final data = await Clipboard.getData('text/plain');
            if(data != null){
              textController.text = data.text!;
            }
          }, icon: const Icon(Icons.paste_rounded), tooltip: 'paste'.tr,),
          IconButton(onPressed: () async {
            final text = textController.text;
            isError.value = _checkConvert(text);
            if(isError.value.isNotEmpty){
              return;
            }

            Constants.copy(text);
          }, icon: const Icon(Icons.copy_rounded), tooltip: 'copy'.tr,),
          IconButton(onPressed: ()=> textController.clear(), icon: const Icon(Icons.clear_rounded), tooltip: "clear".tr,),
        ],
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: Dimen.paddingMedium,),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Dimen.paddingMedium,
            children: [
              DropdownMenu<ConvertItem>(
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                ),
                onSelected: (selected) => convertFrom = selected!,
                initialSelection: convertFrom,
                dropdownMenuEntries: [
                  ConvertItem.ascii,ConvertItem.zawgyi,ConvertItem.unicode
                ].map<DropdownMenuEntry<ConvertItem>>((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
              ),
              const Icon(Icons.keyboard_double_arrow_right_rounded),
              DropdownMenu<ConvertItem>(
                inputDecorationTheme: const InputDecorationTheme(filled: true),
                onSelected: (selected) => convertTo = selected!,
                initialSelection: convertTo,
                dropdownMenuEntries: [
                  ConvertItem.unicode,ConvertItem.zawgyi
                ].map<DropdownMenuEntry<ConvertItem>>((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
              ),
            ],
          ),
          const SizedBox(height: Dimen.paddingSmall),
          Expanded(
            flex: 1,
              child: Padding(
            padding: const EdgeInsets.all(Dimen.paddingMedium),
            child: switch(Theme.of(context).platform){
              TargetPlatform.android || TargetPlatform.iOS => KeyboardActions(
                disableScroll: true,
                config: _buildConfig(context),
                child: _buildTextField(isError),
              ),
              _ => _buildTextField(isError)
            },
          )),

          Padding(
            padding: const EdgeInsets.only(bottom: Dimen.paddingMedium,left: Dimen.paddingMedium,right: Dimen.paddingMedium),
            child: FilledButton.icon(onPressed: (){
              var text = textController.text;
              isError.value = _checkConvert(text);
              if(isError.value.isNotEmpty){
                return;
              }

              if (convertFrom == convertTo) {
                if (convertTo == ConvertItem.unicode) {
                  // If unicode trying to convert unicode
                  text = Rabbit.uni2zg(text);
                  text = Rabbit.zg2uni(text);
                } else if (convertTo == ConvertItem.zawgyi) {
                  // If zawgyi trying to convert zawgyi
                  text = Rabbit.zg2uni(text);
                  text = Rabbit.uni2zg(text);
                }
              } else {
                if (convertFrom == ConvertItem.ascii) {
                  // Convert ascii to unicode or zawgyi
                  text = AM2.convert(text);
                  if (convertTo == ConvertItem.zawgyi) {
                    text = Rabbit.uni2zg(text);
                  }
                } else if (convertFrom == ConvertItem.zawgyi && convertTo == ConvertItem.unicode) {
                  // Convert zawgyi to unicode
                  text = Rabbit.zg2uni(text);
                } else if (convertFrom == ConvertItem.unicode && convertTo == ConvertItem.zawgyi) {
                  // Convert unicode to zawgyi
                  text = Rabbit.uni2zg(text);
                }
              }

              textController.text = text;

            }, label: Text("convert".tr,), icon: const Icon(Icons.transform_rounded),),
          )
        ],
      ),
    );
  }
  
  Widget _buildTextField(RxString isError){
    return Obx(() => TextField(
      focusNode: _nodeText,
      onChanged: (text){
        isError.value = "";
      },
      controller: textController,
      textAlignVertical: TextAlignVertical.top,
      maxLines: null,
      minLines: null,
      expands: true,
      decoration: InputDecoration(
          hintText: 'input_text_here'.tr,
          border: const OutlineInputBorder(),
          errorText: isError.value.isNotEmpty ? isError.value : null
      ),
    ));
  }

  final FocusNode _nodeText = FocusNode();
  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardBarColor: Theme.of(context).colorScheme.secondaryContainer,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
            focusNode: _nodeText,
            toolbarButtons: [
              (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: const Padding(
                    padding: EdgeInsets.all(Dimen.paddingSmall),
                    child: Icon(Icons.keyboard_hide_rounded),
                  ),
                );
              }
        ])
      ],
    );
  }

  String _checkConvert(String text){
    return text.isEmpty ? "text_empty".tr : "";
  }
}
