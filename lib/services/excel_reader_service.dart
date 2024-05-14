import 'package:excel/excel.dart';
import 'dart:io';

class ExcelReaderService {
  List<Map<String, dynamic>> readExcel(File file) {
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<Map<String, dynamic>> data = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];

      for (var row in sheet!.rows) {
        Map<String, dynamic> rowData = {};
        for (var cell in row) {
          rowData[cell!.columnIndex.toString()] = cell.value;
        }
        data.add(rowData);
      }
    }
    return data;
  }
}
