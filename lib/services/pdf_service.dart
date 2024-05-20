import 'package:flutter/foundation.dart';
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
    'MINI 6': {
      'NEW HIRE': 'Statement for MINI 6, NEW HIRE',
      'BREAKFIX - MINI 6 > FULL KIT': 'Statement for MINI 6, BREAKFIX - MINI 6 > FULL KIT',
      'REFRESH': 'Statement for MINI 6, REFRESH',
      'ITS': 'Statement for MINI 6, ITS',
      'DEV': 'Statement for MINI 6, DEV',
    },
    'MOBY': {
      'NEW HIRE': 'Statement for MOBY, NEW HIRE',
      'BREAKFIX - MOBY ONLY': 'Statement for MOBY, BREAKFIX - MOBY ONLY',
      'REFRESH': 'Statement for MOBY, REFRESH',
      'ITS': 'Statement for MOBY, ITS',
      'DEV': 'Statement for MOBY, DEV',
    },
    'AIR 5': {
      'NEW HIRE': 'Statement for AIR 5, NEW HIRE',
      'BREAKFIX - FULL KIT': 'Statement for AIR 5, BREAKFIX - FULL KIT',
      'REFRESH': 'Statement for AIR 5, REFRESH',
      'ITS': 'Statement for AIR 5, ITS',
      'DEV': 'Statement for AIR 5, DEV',
    },
  };

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
      'Ensure the mPOS name is added to BlueFin.',
      'Verify that the mPOS is set to "Activating" on BlueFin.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the Otterbox magnet is properly attached.',
      'Confirm that the mPOS clip is properly attached.',
      'Verify that the mPOS is attached to the iPad.',
      'Ensure that either the hand strap or shoulder strap is attached.',
      'Verify that either the hand strap or shoulder strap is included in the kit.',
      'Confirm the presence of the Apple charging brick (20W) and cable.',
      'Ensure the charging brick (12W) and cable for the mPOS are included.',
      'Verify the assigned CSA\'s name is on the foam pouch.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
      ],
    'CSA - New Hire Dedicated (FULL KIT)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Confirm that the device can be shut down properly.',
      'Ensure the mPOS name is added to BlueFin.',
      'Verify that the mPOS is set to "Activating" on BlueFin.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the Otterbox magnet is properly attached.',
      'Confirm that the mPOS clip is properly attached.',
      'Verify that the mPOS is attached to the iPad.',
      'Ensure that either the hand strap or shoulder strap is attached.',
      'Verify that either the hand strap or shoulder strap is included in the kit.',
      'Confirm the presence of the Apple charging brick (20W) and cable.',
      'Ensure the charging brick (12W) and cable for the mPOS are included.',
      'Verify the assigned CSA\'s name is on the foam pouch.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
    ],
    'CSA - New SHARED (Full Kit)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSASHARED.SHARED".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Confirm that the device can be shut down properly.',
      'Ensure the mPOS name is added to BlueFin.',
      'Verify that the mPOS is set to "Activating" on BlueFin.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the Otterbox magnet is properly attached.',
      'Confirm that the mPOS clip is properly attached.',
      'Verify that the mPOS is attached to the iPad.',
      'Ensure that either the hand strap or shoulder strap is attached.',
      'Verify that either the hand strap or shoulder strap is included in the kit.',
      'Confirm the presence of the Apple charging brick (20W) and cable.',
      'Ensure the charging brick (12W) and cable for the mPOS are included.',
      'Verify the assigned CSA\'s name is on the foam pouch.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
    ],
    'CSA - Break Fix Dedicated (Full Kit)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Confirm that the device can be shut down properly.',
      'Add the mPOS name to BlueFin.',
      'Set the mPOS to "Activating" on BlueFin.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the Otterbox magnet is properly attached.',
      'Confirm that the mPOS clip is properly attached.',
      'Verify that the mPOS is attached to the iPad.',
      'Ensure that either the hand strap or shoulder strap is attached.',
      'Verify that either the hand strap or shoulder strap is included in the kit.',
      'Confirm the presence of the Apple charging brick (20W) and cable.',
      'Ensure the charging brick (12W) and cable for the mPOS are included.',
      'Verify the assigned CSA\'s name is on the foam pouch.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
    ],
    'CSA - Break Fix Dedicated (Device ONLY Kit)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSADEDICATED.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Confirm that the device can be shut down properly.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Confirm that the mPOS clip is properly attached.',
      'Ensure that either the hand strap or shoulder strap is attached.',
      'Verify that either the hand strap or shoulder strap is included in the kit.',
      'Confirm the presence of the Apple charging brick (20W) and cable.',
      'Ensure the charging brick (12W) and cable for the mPOS are included.',
      'Verify the assigned CSA\'s name is on the foam pouch.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
    ],
    'CSA - Break Fix Moby Only (Dedicated or Shared)': [
      'Confirm that the device can be shut down properly.',
      'Add the mPOS name to BlueFin.',
      'Set the mpOS to "Activating" on BlueFin.',
      'Ensure the charging brick (12W) and cable for the mPOS are included.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
    ],
    'CSA - Break Fix SHARED (DEVICE ONLY)': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASCSASHARED.SHARED".',
      'Check if Location Services are enabled on the iPad.',
      'Verify that Bluetooth is turned on.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Confirm that the device can be shut down properly.',
      'Add the mPOS name to BlueFin only if requested.',
      'Set the mpOS to "Activating" on BlueFin only if requested.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the Otterbox magnet is properly attached.',
      'Confirm that the mPOS clip is properly attached only if requested.',
      'Verify that the mPOS is attached to the iPad only if requested.',
      'Ensure that either the hand strap or shoulder strap is attached.',
      'Verify that either the hand strap or shoulder strap is included in the kit.',
      'Confirm the presence of the Apple charging brick (20W) and cable.',
      'Ensure the charging brick (12W) and cable for the mPOS are included only if requested.',
      'Verify the assigned CSA\'s name is on the foam pouch.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
    ],
    'Pilot - New Hire': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASPILOT.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Ensure GoodReader is configured properly.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the presence of the Apple charging brick (20W) and cable if requested.',
      'Verify the name is correct in WS1 if the device is shared.',
      'Confirm that the device can be shut down properly.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
      'Ensure the device is logged within the Mobile In/Out sheet.',
    ],
    'Pilot - BreakFix': [
      'Verify the Alaska Asset label and Device Identifiers on the iPad.',
      'Confirm the application of the Serial, IMEI, and Model labels on the iPad.',
      'Ensure that the Serial and IMEI numbers match those displayed in the iPad\'s settings.',
      'Confirm that the device is staged as "STAGING.ASPILOT.PREDEPLOY".',
      'Check if Location Services are enabled on the iPad.',
      'Ensure the iPad has the most current version of iOS installed.',
      'Confirm the installation of the HUB application.',
      'Verify the cellular connection is operational with the requested carrier.',
      'Ensure GoodReader is configured properly.',
      'Confirm that the Otterbox case is securely on the iPad.',
      'Ensure the presence of the Apple charging brick (20W) and cable.',
      'Confirm that the device can be shut down properly.',
      'Ensure the device is packaged properly for safe shipping.',
      'Confirm the task number and all required labeling are on the shipping box.',
      'Verify the device\'s movement within Odoo.',
      'Ensure the device is logged within the Mobile In/Out sheet.',
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
        build: (pw.Context context) {s
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
