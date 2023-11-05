import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<String> readFavorite(String fav) async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      print(contents);
      //var res = jsonDecode(dir.body);
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    print("object");
    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> writeFavorite(int counter) async {
    final file = await _localFile;
    print("object");
    // Write the file
    return file.writeAsString('$counter');
  }
}