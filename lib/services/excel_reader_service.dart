import "package:excel/excel.dart";
import "package:flutter/services.dart";


Future<List<List<String>>> readExcel(String filePath) async {
  ByteData data = await rootBundle.load(filePath);
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  List<List<String>> rows = [];
  for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
          rows.add(row.map((cell) => cell?.value?.toString() ?? "").toList());
      }
  }
  return rows;
}