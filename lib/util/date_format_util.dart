import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

String getDateFormatted(String date) {
  initializeDateFormatting("ja_JP");

  DateTime datetime = DateTime.parse(date); // StringからDate

  var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
  var formatted = formatter.format(datetime); // DateからString
  return formatted;
}
