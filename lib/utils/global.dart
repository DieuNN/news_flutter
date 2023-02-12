import 'package:get_storage/get_storage.dart';

class GlobalVariables {
  static String currentLanguage = GetStorage().read("currentLanguage") ?? "us";
}
