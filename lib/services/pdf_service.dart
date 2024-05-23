import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:qasheets/UpdateThis/checklists.dart';
import 'package:qasheets/UpdateThis/statements.dart';
import 'excel_reader_service.dart';

class PdfService {
  final ExcelReaderService excelReaderService;

  PdfService(this.excelReaderService);

  String determineStatement(String? deviceType, String? kitType) {
    if (deviceType == null || kitType == null) {
      return 'Unknown Statement';
    }
    return statements[deviceType]?[kitType] ?? 'Default Statement';
  }

  String sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return date; // Return the original date if parsing fails
    }
  }

  List<String>? getChecklist(String? kitType) {
    return checklists[kitType];
  }

  Future<void> generatePdfAndCopyExcel(File excelFile, String userText, String status, Directory exportDirectory) async {
    final excelData = excelReaderService.getExcelData();

    for (var row in excelData) {
      await generatePdf(row, userText, status, exportDirectory);
    }

    // After all PDFs are generated, copy the Excel file to the export directory
    final excelFileName = excelFile.path.split('/').last;
    final outputExcelFile = File('${exportDirectory.path}/$excelFileName');
    await excelFile.copy(outputExcelFile.path);
  }

  Future<String> generatePdf(Map<String, dynamic> row, String userText, String status, Directory exportDirectory) async {
    final pdf = pw.Document();
    bool isCompleted = status == 'completed';

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final deviceType = row['DEVICE TYPE'];
    final kitType = row['KIT TYPE'];
    final title = 'QA Sheet - ${deviceType ?? 'Unknown Device'} - ${kitType ?? 'Unknown Kit'}';

    if (kDebugMode) {
      print('Device Type: $deviceType');
      print('Kit Type: $kitType');
    }

    List<String>? checklist = getChecklist(kitType);
    if (checklist == null) {
      if (kDebugMode) {
        print('No checklist available for kit type: $kitType');
      }
      checklist = ['No checklist available for this combination'];
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
                  if (row['QA (initials)'] != null)
                    pw.Text('QA: ${row['QA (initials)']}', style: pw.TextStyle(fontSize: 14, font: ttf)),
                ],
              ),
              pw.SizedBox(height: 20),
              if (row['CHERWELL TICKET/TASK'] != null)
                _buildTextField('Cherwell Ticket/Task', row['CHERWELL TICKET/TASK'], ttf),
              pw.Row(
                children: [
                  if (row['SN'] != null)
                    _buildTextFieldExpanded('SN', row['SN'], ttf),
                  if (row['IMEI'] != null)
                    _buildTextFieldExpanded('IMEI', row['IMEI'], ttf),
                ],
              ),
              pw.Row(
                children: [
                  if (row['EID'] != null)
                    _buildTextFieldExpanded('EID', row['EID'], ttf),
                  if (row['ACTIVATION DATE'] != null)
                    _buildTextFieldExpanded('Activation Date', formatDate(row['ACTIVATION DATE']), ttf),
                ],
              ),
              pw.Row(
                children: [
                  if (row['MAGTEK SN'] != null)
                    _buildTextFieldExpanded('MagTek SN', row['MAGTEK SN'], ttf),
                  if (row['BATTERY %'] != null)
                    _buildTextFieldExpanded('Battery %', row['BATTERY %'], ttf),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Checklist:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.SizedBox(height: 10),
              for (var item in checklist!)
                _buildChecklist(item, isCompleted, ttf),
            ],
          );
        },
      ),
    );

    String fileName = sanitizeFileName('${row['KIT TYPE'] ?? 'unknown'}_${row['DEVICE TYPE'] ?? 'unknown'}_${row['SN'] ?? 'unknown'}_${row['IMEI'] ?? 'unknown'}.pdf');
    final outputFile = File('${exportDirectory.path}/$fileName');
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);
    return outputFile.path;
  }

  pw.Widget _buildTextField(String label, String? value, pw.Font ttf) {
    return pw.Row(
      children: [
        pw.Text('$label: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
        pw.Expanded(child: pw.Text(value ?? '', style: pw.TextStyle(font: ttf))),
      ],
    );
  }

  pw.Widget _buildTextFieldExpanded(String label, String? value, pw.Font ttf) {
    return pw.Expanded(
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
          pw.Text(value ?? '', style: pw.TextStyle(font: ttf)),
        ],
      ),
    );
  }

  pw.Widget _buildChecklist(String label, bool isChecked, pw.Font ttf) {
    return pw.Row(
      children: [
        pw.Container(
          width: 12,
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: isChecked
              ? pw.Center(
                  child: pw.Container(
                    width: 8,
                    height: 8,
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.black,
                    ),
                  ),
                )
              : null,
        ),
        pw.SizedBox(width: 4),
        pw.Text(label, style: pw.TextStyle(font: ttf)),
      ],
    );
  }
}
