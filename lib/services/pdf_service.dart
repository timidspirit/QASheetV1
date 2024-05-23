import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart'; 
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class PdfService {
  final Map<String, Map<String, String>> statements = {
    'IPHONE 12': { //Update Field and below when changing the excel import sheet
      'DEV': 'Statement for IPHONE 12, DEV',
      'ITS': 'Statement for IPHONE 12, ITS',
      'OTHER': 'Statement for IPHONE 12, OTHER',
      'AS InFlight New Hire Dedicated (FULL KIT)': 'Statement for IPHONE 12, AS InFlight New Hire Dedicated (FULL KIT)',
      'AS InFlight New SHARED (Full Kit)': 'Statement for IPHONE 12, AS InFlight New SHARED (Full Kit)',
      'AS Break Fix Dedicated (Full Kit)': 'Statement for IPHONE 12, AS Break Fix Dedicated (Full Kit)',
      'AS Break Fix Dedicated (Device ONLY Kit)': 'Statement for IPHONE 12, AS Break Fix Dedicated (Device ONLY Kit)',
      'AS Break Fix SHARED (DEVICE ONLY)': 'Statement for IPHONE 12, AS Break Fix SHARED (DEVICE ONLY)',
      'AS InFlight CLASS Dedicated (FULL KIT)': 'Statement for IPHONE 12, AS InFlight CLASS Dedicated (FULL KIT)',
      'QX InFlight New Hire Dedicated (FULL KIT)': 'Statement for IPHONE 12, QX InFlight New Hire Dedicated (FULL KIT)',
      'QX InFlight New SHARED (Full Kit)': 'Statement for IPHONE 12, QX InFlight New SHARED (Full Kit)',
      'QX Break Fix Dedicated (Full Kit)': 'Statement for IPHONE 12, QX Break Fix Dedicated (Full Kit)',
      'QX Break Fix Dedicated (Device ONLY Kit)': 'Statement for IPHONE 12, QX Break Fix Dedicated (Device ONLY Kit)',
      'QX Break Fix SHARED (DEVICE ONLY)': 'Statement for IPHONE 12, QX Break Fix SHARED (DEVICE ONLY)',
      'QX InFlight CLASS Dedicated (FULL KIT)': 'Statement for IPHONE 12, QX InFlight CLASS Dedicated (FULL KIT)',
      //Add More Statements Here
    },
    'IPHONE 13': { //Update Field and below when changing the excel import sheet
      'DEV': 'Statement for IPHONE 13, DEV',
      'ITS': 'Statement for IPHONE 13, ITS',
      'OTHER': 'Statement for IPHONE 13, OTHER',
      'AS InFlight New Hire Dedicated (FULL KIT)': 'Statement for IPHONE 13, AS InFlight New Hire Dedicated (FULL KIT)',
      'AS InFlight New SHARED (Full Kit)': 'Statement for IPHONE 13, AS InFlight New SHARED (Full Kit)',
      'AS Break Fix Dedicated (Full Kit)': 'Statement for IPHONE 13, AS Break Fix Dedicated (Full Kit)',
      'AS Break Fix Dedicated (Device ONLY Kit)': 'Statement for IPHONE 13, AS Break Fix Dedicated (Device ONLY Kit)',
      'AS Break Fix SHARED (DEVICE ONLY)': 'Statement for IPHONE 13, AS Break Fix SHARED (DEVICE ONLY)',
      'AS InFlight CLASS Dedicated (FULL KIT)': 'Statement for IPHONE 13, AS InFlight CLASS Dedicated (FULL KIT)',
      'QX InFlight New Hire Dedicated (FULL KIT)': 'Statement for IPHONE 13, QX InFlight New Hire Dedicated (FULL KIT)',
      'QX InFlight New SHARED (Full Kit)': 'Statement for IPHONE 13, QX InFlight New SHARED (Full Kit)',
      'QX Break Fix Dedicated (Full Kit)': 'Statement for IPHONE 13, QX Break Fix Dedicated (Full Kit)',
      'QX Break Fix Dedicated (Device ONLY Kit)': 'Statement for IPHONE 13, QX Break Fix Dedicated (Device ONLY Kit)',
      'QX Break Fix SHARED (DEVICE ONLY)': 'Statement for IPHONE 13, QX Break Fix SHARED (DEVICE ONLY)',
      'QX InFlight CLASS Dedicated (FULL KIT)': 'Statement for IPHONE 13, QX InFlight CLASS Dedicated (FULL KIT)',
      //Add More Statements Here
    },
    'IPHONE 15': { //Update Field and below when changing the excel import sheet
      'Refresh': 'Statement for IPHONE 15, Refresh',
      'DEV': 'Statement for IPHONE 15, DEV',
      'ITS': 'Statement for IPHONE 15, ITS',
      'OTHER': 'Statement for IPHONE 15, OTHER',
      'AS InFlight New Hire Dedicated (FULL KIT)': 'Statement for IPHONE 15, AS InFlight New Hire Dedicated (FULL KIT)',
      'AS InFlight New SHARED (Full Kit)': 'Statement for IPHONE 15, AS InFlight New SHARED (Full Kit)',
      'AS Break Fix Dedicated (Full Kit)': 'Statement for IPHONE 15, AS Break Fix Dedicated (Full Kit)',
      'AS Break Fix Dedicated (Device ONLY Kit)': 'Statement for IPHONE 15, AS Break Fix Dedicated (Device ONLY Kit)',
      'AS Break Fix SHARED (DEVICE ONLY)': 'Statement for IPHONE 15, AS Break Fix SHARED (DEVICE ONLY)',
      'AS InFlight CLASS Dedicated (FULL KIT)': 'Statement for IPHONE 15, AS InFlight CLASS Dedicated (FULL KIT)',
      'QX InFlight New Hire Dedicated (FULL KIT)': 'Statement for IPHONE 15, QX InFlight New Hire Dedicated (FULL KIT)',
      'QX InFlight New SHARED (Full Kit)': 'Statement for IPHONE 15, QX InFlight New SHARED (Full Kit)',
      'QX Break Fix Dedicated (Full Kit)': 'Statement for IPHONE 15, QX Break Fix Dedicated (Full Kit)',
      'QX Break Fix Dedicated (Device ONLY Kit)': 'Statement for IPHONE 15, QX Break Fix Dedicated (Device ONLY Kit)',
      'QX Break Fix SHARED (DEVICE ONLY)': 'Statement for IPHONE 15, QX Break Fix SHARED (DEVICE ONLY)',
      'QX InFlight CLASS Dedicated (FULL KIT)': 'Statement for IPHONE 15, QX InFlight CLASS Dedicated (FULL KIT)',
      //Add More Statements Here
    },
    'MINI 6': { //Update Field and below when changing the excel import sheet
      'REFRESH': 'Statement for MINI 6, REFRESH',
      'ITS': 'Statement for MINI 6, ITS',
      'DEV': 'Statement for MINI 6, DEV',
      'CSA New Hire Dedicated (FULL KIT)': 'Statement for MINI 6, CSA New Hire Dedicated (FULL KIT)',
      'CSA New SHARED (Full Kit)': 'Statement for MINI 6, CSA New SHARED (Full Kit)',
      'Break Fix Dedicated (Full Kit)': 'Statement for MINI 6, Break Fix Dedicated (Full Kit)',
      'Break Fix Dedicated (Device ONLY Kit)': 'Statement for MINI 6, Break Fix Dedicated (Device ONLY Kit)',
      'Break Fix SHARED (DEVICE ONLY)': 'Statement for MINI 6, Break Fix SHARED (DEVICE ONLY)',
      //Add More Statements Here
    },
    'MOBY': { //Update Field and below when changing the excel import sheet
      'NEW HIRE': 'Statement for MOBY, NEW HIRE',
      'BREAKFIX - MOBY ONLY': 'Statement for MOBY, BREAKFIX - MOBY ONLY',
      'REFRESH': 'Statement for MOBY, REFRESH',
      'ITS': 'Statement for MOBY, ITS',
      'DEV': 'Statement for MOBY, DEV',
      //Add More Statements Here
    },
    'AIR 5': { //Update Field and below when changing the excel import sheet
      'AS Pilot - New Hire (DEDICATED)': 'Statement for AIR 5, AS Pilot - New Hire (DEDICATED)',
      'AS Pilot - BreakFix (DEDICATED)': 'Statement for AIR 5, AS Pilot - BreakFix (DEDICATED)',
      'AS Pilot - BreakFix (SHARED)': 'Statement for AIR 5, AS Pilot - BreakFix (SHARED)',
      'QX Pilot - New Hire (DEDICATED)': 'Statement for AIR 5, QX Pilot - New Hire (DEDICATED)',
      'QX Pilot - BreakFix (DEDICATED)': 'Statement for AIR 5, QX Pilot - BreakFix (DEDICATED)',
      'QX Pilot - BreakFix (SHARED)': 'Statement for AIR 5, QX Pilot - BreakFix (SHARED)',
      //Add More Statements Here
    },
  };
}


  final Map<String, Map<String, List<String>>> checklistItems = {
    'MINI 6': {
      'NEW HIRE': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Confirm that the device can be shut down properly.',

      ],
    'CSA - New Hire Dedicated (FULL KIT)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',

    ],
    'CSA - New SHARED (Full Kit)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSASHARED.SHARED".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',

    ],
    'CSA - Break Fix Dedicated (Full Kit)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',

    ],
    'CSA - Break Fix Dedicated (Device ONLY Kit)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',

    ],
    'CSA - Break Fix Moby Only (Dedicated or Shared)': [
      'Confirm that the device can be shut down properly.',
      'Add the mPOS name to BlueFin.',

    ],
    'CSA - Break Fix SHARED (DEVICE ONLY)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSASHARED.SHARED".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
    ],
    'Pilot - New Hire': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASPILOT.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Ensure the iPad has the most current version of iOS installed.',
    ],
    'Pilot - BreakFix': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Confirm the application of the Serial, IMEI, and Model labels on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
    ],
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

    // Debugging logs to ensure correct device type and kit type are being used
    if (kDebugMode) {
      print('Device Type: $deviceType');
    }
    if (kDebugMode) {
      print('Kit Type: $kitType');
    }

    List<String>? checklist = checklistItems[deviceType]?[kitType];
    if (checklist == null) {
      if (kDebugMode) {
        print('No checklist available for device type: $deviceType and kit type: $kitType');
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
