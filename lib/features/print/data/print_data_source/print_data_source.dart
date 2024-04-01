import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/print_model.dart';

class PrintDataSource {
  PrintDataSource._();

  static void setIsUsePrint(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IS_USE_PRINT_KEY', value);
  }

  static Future<bool?> getIsUsePrint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('IS_USE_PRINT_KEY');
  }

  static void setPrint(PrintModel printModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('PRINT_KEY', jsonEncode(printModel.toJson()));
  }

  static Future<PrintModel?> getPrint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('PRINT_KEY') ?? '';
    if (data.isEmpty) {
      return PrintModel();
    }
    return PrintModel.fromJson(jsonDecode(data));
  }
}
