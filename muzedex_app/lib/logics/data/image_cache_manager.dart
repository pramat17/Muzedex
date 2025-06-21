import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:path_provider/path_provider.dart';

class ImageCacheManager {
  final Dio _dio = Dio();
  final FileManager fileManager = FileManager();

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _isImageDownloaded(String filename) async {
    final path = await _getLocalPath();
    return File('$path/$filename').exists();
  }

  Future<void> cacheImages() async {
    final path = await _getLocalPath();
    final Map<String, String> imagePaths = {};

    final directoryPath = await fileManager.getDirectoryPath();
    final dataFile = File('$directoryPath/data.json');

    if (await dataFile.exists()) {
      final data = json.decode(await dataFile.readAsString());

      for (var room in data['rooms']) {
        for (var item in room['items']) {
          final name = item['name'];
          final url = item['imageLink'];
          final filename = Uri.parse(url).pathSegments.last.split('?').first;
          final filePath = '$path/$filename';

          if (!await _isImageDownloaded(filename)) {
            await _dio.download(url, filePath);
            imagePaths[name] = filePath;
          } else {
            imagePaths[name] = filePath;
          }
        }
      }

      await _updateDataJson(imagePaths);
    }
  }

  Future<String?> getLocalImagePath(String imageUrl) async {
    final filename = Uri.parse(imageUrl).pathSegments.last.split('?').first;
    final path = await _getLocalPath();
    final localFile = File('$path/$filename');

    return localFile.existsSync() ? localFile.path : null;
  }

  Future<void> _updateDataJson(Map<String, String> imagePaths) async {
    final directoryPath = await fileManager.getDirectoryPath();
    final dataFile = File('$directoryPath/data.json');

    if (await dataFile.exists()) {
      final data = json.decode(await dataFile.readAsString());

      for (var room in data['rooms']) {
        for (var item in room['items']) {
          final name = item['name'];
          if (imagePaths.containsKey(name)) {
            item['imageLink'] = imagePaths[name];
          }
        }
      }

      await dataFile.writeAsString(json.encode(data));
    }
  }
}
