import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class ExcelReaderService {
  List<Map<String, dynamic>> _excelData = [];

  List<Map<String, dynamic>> readExcel(File file) {
    _excelData.clear(); // Clear previous data
    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];

        if (sheet != null) {
          List<String> headers = [];

          for (var i = 0; i < sheet.maxColumns; i++) {
            headers.add(sheet.rows[0][i]?.value?.toString() ?? '');
          }

          for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
            var row = sheet.rows[rowIndex];
            Map<String, dynamic> rowData = {};

            for (var colIndex = 0; colIndex < headers.length; colIndex++) {
              rowData[headers[colIndex]] = row[colIndex]?.value?.toString();
            }

            _excelData.add(rowData);
          }
        }
      }

      // Print the data to verify it is read correctly
      if (kDebugMode) {
        print(_excelData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading Excel file: $e');
      }
    }

    return _excelData;
  }

  void setExcelData(List<Map<String, dynamic>> excelData) {
    _excelData = excelData;
  }

  List<Map<String, dynamic>> getExcelData() {
    return _excelData;
  }
}
