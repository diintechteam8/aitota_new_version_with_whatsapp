import 'dart:io';
import 'package:excel/excel.dart';

import '../../../../../../core/app-export.dart';
import '../../add_contact/controller/add_contact_controller.dart';


class ImportFileController extends GetxController {
  final AddContactController _addContactController = Get.find<AddContactController>();

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // Fallback for Android 13+ (if you're using READ_MEDIA_FILES instead of storage)
      if (await Permission.photos.request().isGranted) {
        return true;
      }

      Get.snackbar('Error', 'Storage permission denied. Please enable it in settings.');
      await openAppSettings();
      return false;
    }

    return true;
  }


  Future<void> pickAndImportFile(List<String> allowedExtensions) async {
    try {
      print('Attempting to pick file with extensions: $allowedExtensions');
      if (!await _requestStoragePermission()) {
        print('Permission denied');
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      print('FilePickerResult: $result');
      if (result == null || result.files.single.path == null) {
        Get.snackbar('Info', 'No file selected');
        print('No file selected');
        return;
      }

      String filePath = result.files.single.path!;
      print('Selected file path: $filePath');
      List<Map<String, dynamic>> importedContacts = [];

      if (allowedExtensions.contains('csv')) {
        importedContacts = await _importCsvFile(filePath);
      } else if (allowedExtensions.contains('xls') || allowedExtensions.contains('xlsx')) {
        importedContacts = await _importExcelFile(filePath);
      }

      print('Imported contacts count: ${importedContacts.length}');
      if (importedContacts.isNotEmpty) {
        _addContactController.addImportedContacts(importedContacts);
        Get.back();
        Get.snackbar('Success', 'Imported ${importedContacts.length} contacts');
      } else {
        Get.snackbar('Error', 'No valid contacts found in the file');
        print('No valid contacts found');
      }
    } on PlatformException catch (e) {
      Get.snackbar('Error', 'Platform error: ${e.message}');
      print('PlatformException: ${e.details}');
    } catch (e, stackTrace) {
      Get.snackbar('Error', 'Failed to import file: $e');
      print('Import Error: $e\nStackTrace: $stackTrace');
    }
  }

  Future<List<Map<String, dynamic>>> _importCsvFile(String filePath) async {
    try {
      print('Importing CSV from: $filePath');
      final file = File(filePath);
      final input = await file.readAsString();
      List<List<dynamic>> rows = const CsvToListConverter().convert(input);

      List<Map<String, dynamic>> contacts = [];
      if (rows.isNotEmpty) {
        for (var row in rows.skip(1)) {
          if (row.length >= 2) {
            contacts.add({
              'name': row[0]?.toString().trim() ?? '',
              'phone': row[1]?.toString().trim() ?? '',
              'email': row.length > 2 ? row[2]?.toString().trim() ?? '' : '',
              'createdAt': DateTime.now().toIso8601String(),
              'contactCount': 1,
              'isImported': true,
            });
          }
        }
      }
      print('CSV contacts parsed: ${contacts.length}');
      return contacts;
    } catch (e, stackTrace) {
      print('CSV Import Error: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _importExcelFile(String filePath) async {
    try {
      print('Importing Excel from: $filePath');
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> contacts = [];
      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet != null) {
          for (var row in sheet.rows.skip(1)) {
            if (row.length >= 2) {
              contacts.add({
                'name': row[0]?.value?.toString().trim() ?? '',
                'phone': row[1]?.value?.toString().trim() ?? '',
                'email': row.length > 2 ? row[2]?.value?.toString().trim() ?? '' : '',
                'createdAt': DateTime.now().toIso8601String(),
                'contactCount': 1,
                'isImported': true,
              });
            }
          }
        }
      }
      print('Excel contacts parsed: ${contacts.length}');
      return contacts;
    } catch (e, stackTrace) {
      print('Excel Import Error: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }
}