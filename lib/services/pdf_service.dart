// ignore: unused_import
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class PdfService {
  void generatePdf(List<Map<String, dynamic>> data, String userText, String status) {
    final pdf = pw.Document();

    for (var row in data) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('User Input: $userText'),
                pw.Text('Status: $status'),
                pw.Text('Excel Data:'),
                pw.ListView.builder(
                  itemCount: row.keys.length,
                  itemBuilder: (context, index) {
                    String key = row.keys.elementAt(index);
                    return pw.Text('$key: ${row[key]}');
                  },
                ),
              ],
            );
          },
        ),
      );
    }

    final output = File('output.pdf');
    output.writeAsBytesSync(pdf.save() as List<int>);
  }
}
