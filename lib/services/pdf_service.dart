import 'package:pdf/pdf.dart'; // Ensure this import is present
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class PdfService {
  final Map<String, Map<String, String>> statements = {
    'IPHONE 12': {
      'NEW HIRE': 'Statement for IPHONE 12, NEW HIRE',
      'WEB|NHR': 'Statement for IPHONE 12, WEB|NHR',
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
      'BREAKFIX - 13 > DEVICE AND': 'Statement for IPHONE 13, BREAKFIX - 13 > DEVICE AND',
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

  Future<String> generatePdf(Map<String, dynamic> row, String userText, String status, Directory exportDirectory) async {
    final pdf = pw.Document();
    bool isCompleted = status == 'completed';

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final deviceType = row['DEVICE TYPE'];
    final kitType = row['KIT TYPE'];
    final title = 'QA Sheet - ${deviceType ?? 'Unknown Device'} - ${kitType ?? 'Unknown Kit'}';
    
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
              _buildChecklist('Alaska Asset label Applied to iPad?', isCompleted, ttf),
              _buildChecklist('Serial /IMEI/Model Label Applied to iPad?', isCompleted, ttf),
              _buildChecklist('Serial & IMEI same as displayed in Settings?', isCompleted, ttf),
              _buildChecklist('Staged as "STAGING.ASIF.PREDEPLOY"?', isCompleted, ttf),
              _buildChecklist('Location Services Enabled?', isCompleted, ttf),
              _buildChecklist('Bluetooth Turned On?', isCompleted, ttf),
              _buildChecklist('Most current version of iOS installed?', isCompleted, ttf),
              _buildChecklist('HUB Application Installed?', isCompleted, ttf),
              _buildChecklist('Cellular Connection verified working with requested Carrier?', isCompleted, ttf),
              _buildChecklist('GoodReader Configured?', isCompleted, ttf),
              _buildChecklist('MagTek Name Added to BlueFin? - IF REQUESTED', isCompleted, ttf),
              _buildChecklist('MagTek set to "Activating" Bluefin? - IF REQUESTED', isCompleted, ttf),
              _buildChecklist('Otterbox Case on?', isCompleted, ttf),
              _buildChecklist('MagTek Clip on? - IF REQUESTED', isCompleted, ttf),
              _buildChecklist('MagTek attached? - IF REQUESTED', isCompleted, ttf),
              _buildChecklist('Apple charging brick (20W) & Cable? - IF REQUESTED', isCompleted, ttf),
              _buildChecklist('Name correct in WS1 if shared?', isCompleted, ttf),
              _buildChecklist('Shutdown of device?', isCompleted, ttf),
              _buildChecklist('Packaged properly for safe shipping?', isCompleted, ttf),
              _buildChecklist('Task Number & All required labeling on ship box?', isCompleted, ttf),
              _buildChecklist('Moved within Odoo?', isCompleted, ttf),
              _buildChecklist('Logged within Mobile In/Out Sheet?', isCompleted, ttf),
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
