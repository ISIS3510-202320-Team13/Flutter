import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFileByAtribute(String atribute) async {
    final path = await _localPath;
    return File('$path/$atribute.cnf');
  }

  Future<String> readSimpleFile(String atribute) async {
    try {
      final file = await _localFileByAtribute(atribute);

      // Read the file
      final contents = await file.readAsString();
      //var res = jsonDecode(dir.body);
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeSimpleFile(String atribute, String dir) async {
    final file = await _localFileByAtribute(atribute);
    // Write the file
    return file.writeAsString('$dir');
  }

  Future<String> readAsMap(String atribute) async {
    try {
      final file = await _localFileByAtribute(atribute);

      // Read the file
      final contents = await file.readAsString();
      var res = jsonDecode(contents);

      return res;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeAsMap(String atribute, Map dir) async {
    final file = await _localFileByAtribute(atribute);
    // Write the file
    return file.writeAsString(dir.toString());
  }
}