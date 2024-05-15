// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

const Map<String, Map<String, String>> inflightStatements = {
  'IPHONE 12': {
    'DEV': 'Statement for IPHONE 12, DEV',
    'BREAKFIX - 12 > FULL KIT': 'Statement for IPHONE 12, BREAKFIX - 12 > FULL KIT',
    'BREAKFIX - 12 > NO MAGTEK': 'Statement for IPHONE 12, BREAKFIX - 12 > NO MAGTEK',
    'ITS': 'Statement for IPHONE 12, ITS',
    'OTHER': 'Statement for IPHONE 12, OTHER',
  },
  'IPHONE 13': {
    'NEW HIRE': 'Statement for IPHONE 13, NEW HIRE',
    'WEB|NHR': 'Statement for IPHONE 13, WEB|NHR',
    'Refresh': 'Statement for IPHONE 13, Refresh',
    'DEV': 'Statement for IPHONE 13, DEV',
    'BREAKFIX - 13 > FULL KIT': 'Statement for IPHONE 13, BREAKFIX - 13 > FULL KIT',
    'BREAKFIX - 15 > DEVICE AND': 'Statement for IPHONE 13, BREAKFIX - 15 > DEVICE AND',
    'ITS': 'Statement for IPHONE 13, ITS',
    'OTHER': 'Statement for IPHONE 13, OTHER',
  },
  'IPHONE 15': {
    'NEW HIRE': 'Statement for IPHONE 15, NEW HIRE',
    'WEB|NHR': 'Statement for IPHONE 15, WEB|NHR',
    'Refresh': 'Statement for IPHONE 15, Refresh',
    'DEV': 'Statement for IPHONE 15, DEV',
    'BREAKFIX - 15 > FULL KIT': 'Statement for IPHONE 15, BREAKFIX - 15 > FULL KIT',
    'BREAKFIX - 15 > DEVICE AND': 'Statement for IPHONE 15, BREAKFIX - 15 > DEVICE AND',
    'ITS': 'Statement for IPHONE 15, ITS',
    'OTHER': 'Statement for IPHONE 15, OTHER',
  },
};



class PdfService {
  String determineStatement(String? deviceType, String? kitType) {
    if (deviceType == null || kitType == null) {
      return 'No statement found due to missing data.';
    }
    return inflightStatements[deviceType]?[kitType] ?? 'No statement found for this combination.';
  }

  Future<String> generatePdf(List<Map<String, dynamic>> data, String userText, String status) async {
    final pdf = pw.Document();

    for (var row in data) {
      String? deviceType = row['DEVICE TYPE'] as String?;
      String? kitType = row['KIT TYPE'] as String?;
      String statement = determineStatement(deviceType, kitType);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('User Input: $userText'),
                pw.Text('Status: $status'),
                pw.Text('Statement: $statement'),
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

    final directory = await getApplicationDocumentsDirectory();
    final outputFile = File('${directory.path}/output.pdf');
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);
    return outputFile.path;
  }
}