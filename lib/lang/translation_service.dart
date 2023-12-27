import 'package:get/get.dart';
import 'package:pao_library/lang/en_US.dart';
import 'package:pao_library/lang/pao_BLK.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': english,
    'pao_BLK': pao,
  };
}