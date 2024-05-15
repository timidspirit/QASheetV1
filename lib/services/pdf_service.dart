import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
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
    // Replace invalid characters with underscores
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  Future<String> generatePdf(Map<String, dynamic> row, String userText, String status, Directory exportDirectory) async {
    print("Starting PDF generation for row: $row");

    final pdf = pw.Document();
    bool isCompleted = status == 'completed';

    // Load the Roboto font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    print("Font loaded successfully");

    // Removed the statement section as requested

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('QA Sheet', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.SizedBox(height: 20),
              _buildTextField('Cherwell Ticket/Task', row['CHERWELL TICKET/TASK'], ttf),
              _buildTextField('Device Type', row['DEVICE TYPE'], ttf),
              _buildTextField('SN', row['SN'], ttf),
              _buildTextField('IMEI', row['IMEI'], ttf),
              _buildTextField('EID', row['EID'], ttf),
              _buildTextField('Activation Date', row['ACTIVATION DATE'], ttf),
              _buildTextField('MagTek SN', row['MAGTEK SN'], ttf),
              _buildTextField('Kit Type', row['KIT TYPE'], ttf),
              _buildTextField('Battery %', row['BATTERY %'], ttf),
              _buildTextField('QA (initials)', row['QA (initials)'], ttf),
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

    print("Page added to PDF");

    String fileName = sanitizeFileName('${row['KIT TYPE'] ?? 'unknown'}_${row['DEVICE TYPE'] ?? 'unknown'}_${row['SN'] ?? 'unknown'}_${row['IMEI'] ?? 'unknown'}.pdf');
    final outputFile = File('${exportDirectory.path}/$fileName');
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);
    print("PDF saved to: ${outputFile.path}");
    return outputFile.path; // Return the path of the saved PDF
  }

  pw.Widget _buildTextField(String label, String? value, pw.Font ttf) {
    return pw.Row(
      children: [
        pw.Text('$label: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
        pw.Expanded(child: pw.Text(value ?? '', style: pw.TextStyle(font: ttf))),
      ],
    );
  }

  pw.Widget _buildChecklist(String label, bool isChecked, pw.Font ttf) {
    return pw.Row(
      children: [
        pw.Text(
          isChecked ? '✓' : '☐',
          style: pw.TextStyle(font: ttf, fontSize: 18),
        ),
        pw.SizedBox(width: 4),
        pw.Text(label, style: pw.TextStyle(font: ttf)),
      ],
    );
  }
}