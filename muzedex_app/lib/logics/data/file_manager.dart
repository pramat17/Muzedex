import 'dart:convert';
import 'dart:io';

import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:path_provider/path_provider.dart';

// coverage:ignore-file

class FileManager {
  static FileManager _instance = FileManager._internal();

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance;

  // Récupération du chemin du répertoire de stockage
  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    // print(directory.path);
    return directory.path;
  }

  // Récupération du fichier JSON
  Future<File> get _jsonFile async {
    final path = await _directoryPath;
    return File('$path/data.json');
  }

  // Récupération du fichier GameData JSON
  Future<File> get _gameDataJsonFile async {
    final path = await _directoryPath;
    return File('$path/gameData.json');
  }

  // Lecture du fichier JSON
  Future<Map<String, dynamic>?> readJsonFile() async {
    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        String fileContent = await file.readAsString();
        return json.decode(fileContent) as Map<String, dynamic>;
      } catch (e) {
        // print('Erreur lors de la lecture du fichier JSON : $e');
      }
    } else {
      // print('Le fichier JSON n\'existe pas.');
    }

    return null;
  }

  Future<List<Future<Room>>> readRoomsFromJsonFile() async {
    Map<String, dynamic>? jsonData = await readJsonFile();
    if (jsonData != null) {
      List<dynamic> roomsJson = jsonData['rooms'];
      return roomsJson
          .map((roomJson) => Room.fromJson(
                roomJson,
              ))
          .toList();
    } else {
      return [];
    }
  }

  // Écriture dans le fichier JSON
  Future<Map<String, dynamic>> writeJsonFile(
      Map<String, dynamic> jsonData) async {
    File file = await _jsonFile;

    try {
      await file.writeAsString(json.encode(jsonData));
      // print('Fichier JSON écrit avec succès.');
    } catch (e) {
      // print('Erreur lors de l\'écriture du fichier JSON : $e');
    }
    return jsonData;
  }

  // Suppression du fichier JSON
  Future<void> deleteJsonFile() async {
    File file = await _jsonFile;
    if (await file.exists()) {
      try {
        await file.delete();
        // print('Fichier JSON supprimé avec succès.');
      } catch (e) {
        // print('Erreur lors de la suppression du fichier JSON : $e');
      }
    } else {
      // print('Le fichier JSON n\'existe pas.');
    }
  }

  // Mise à jour de l'attribut isFound d'un objet dans le fichier JSON
  Future<void> updateItemIsFound(int itemId) async {
    Map<String, dynamic>? jsonData = await readJsonFile();

    if (jsonData != null && jsonData.containsKey('rooms')) {
      List<dynamic> rooms = jsonData['rooms'];

      for (var room in rooms) {
        if (room.containsKey('items')) {
          List<dynamic> items = room['items'];
          for (var item in items) {
            if (item['id'] == itemId) {
              item['isFound'] = true;
              break;
            }
          }
        }
      }

      await writeJsonFile(jsonData);
    }
  }

  // Mise à jour de l'attribut isRevealed d'un objet dans le fichier JSON
  Future<void> updateItemIsRevealed(int itemId) async {
    Map<String, dynamic>? jsonData = await readJsonFile();

    if (jsonData != null && jsonData.containsKey('rooms')) {
      List<dynamic> rooms = jsonData['rooms'];

      for (var room in rooms) {
        if (room.containsKey('items')) {
          List<dynamic> items = room['items'];
          for (var item in items) {
            if (item['id'] == itemId) {
              item['isRevealed'] = true;
              break;
            }
          }
        }
      }

      await writeJsonFile(jsonData);
    }
  }

  // GESTION DU GAME DATA JSON

  // Lecture du fichier GameData JSON
  Future<Map<String, dynamic>?> readGameDataJsonFile() async {
    File file = await _gameDataJsonFile;

    if (await file.exists()) {
      try {
        String fileContent = await file.readAsString();
        return json.decode(fileContent) as Map<String, dynamic>;
      } catch (e) {
        // print('Erreur lors de la lecture du fichier GameData JSON : $e');
      }
    } else {
      // print('Le fichier GameData JSON n\'existe pas.');
    }

    return null;
  }

  // Écriture dans le fichier GameData JSON
  Future<Map<String, dynamic>> writeGameDataJsonFile(
      Map<String, dynamic> jsonData) async {
    File file = await _gameDataJsonFile;

    try {
      await file.writeAsString(json.encode(jsonData));
      // print('Fichier GameData JSON écrit avec succès.');
    } catch (e) {
      // print('Erreur lors de l\'écriture du fichier GameData JSON : $e');
    }
    return jsonData;
  }

  Future<bool> hasAlreadyPlayed() async {
    final data = await readGameDataJsonFile();
    return data?['hasAlreadyPlayed'] ?? false;
  }

  Future<void> setHasAlreadyPlayed(bool value) async {
    final data = await readGameDataJsonFile() ?? {};
    data['hasAlreadyPlayed'] = value;
    await writeGameDataJsonFile(data);
  }

  Future<bool> hasPlayerName() async {
    final data = await readGameDataJsonFile();
    return data?['name'] != null && data!['name'].toString().trim().isNotEmpty;
  }

  Future<void> setPlayerName(String value) async {
    final data = await readGameDataJsonFile() ?? {};
    data['name'] = value;
    await writeGameDataJsonFile(data);
  }

  Future<void> setStartTimestamp() async {
    final data = await readGameDataJsonFile() ?? {};
    data['startTimestamp'] = DateTime.now().millisecondsSinceEpoch;
    await writeGameDataJsonFile(data);
  }

  Future<int?> getStartTimestamp() async {
    final data = await readGameDataJsonFile() ?? {};
    return data['startTimestamp'];
  }

  Future<String?> getPlayerName() async {
    final data = await readGameDataJsonFile();
    return data?['name'];
  }

  Future<String> getDirectoryPath() async {
    String path = await _directoryPath;
    return path;
  }
}
