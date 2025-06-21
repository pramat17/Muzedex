import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/logics/data/image_cache_manager.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/item_service.dart';

// coverage:ignore-file

class RoomService {
  final String apiUrl;
  final ItemService itemService;
  final FileManager fileManager = FileManager();

  RoomService(this.apiUrl, this.itemService);

  Future<List<Room>> fetchRooms({required Function(double) onProgress}) async {
    // CHECK IF ROOMS ARE ALREADY STORED IN LOCAL STORAGE

    // IF THE APP IS NOT A WEB APP
    if (!kIsWeb) {
      final List<Future<Room>> roomsFromJson =
          await fileManager.readRoomsFromJsonFile();

      if (roomsFromJson.isNotEmpty) {
        // SELECT THE ROOMS FROM THE REQUESTED FLOOR
        return Future.wait(roomsFromJson).then((rooms) {
          return rooms.toList();
        });
      }
    }

    // Vérifier la connexion Internet
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw Exception(
          'Pas de connexion Internet et aucune donnée locale disponible.');
    }

    final url = Uri.parse('$apiUrl/api/rooms');
    final response = await http.get(
      url,
      headers: {'accept': 'application/ld+json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> members = data['hydra:member'];

      List<Room> rooms = [];
      int totalItems = members.length;
      int loadedItems = 0;

      for (var roomJson in members) {
        Room room = await Room.fromJsonFetchingItems(roomJson, itemService);
        rooms.add(room);
        loadedItems++;
        onProgress(loadedItems / totalItems);
      }

      // WRITE THE ROOMS TO LOCAL STORAGE
      if (!kIsWeb) {
        await fileManager.writeJsonFile({
          'rooms': rooms.map((room) => room.toJson()).toList(),
        });
      }

      // DOWNLOAD AND CACHE THE IMAGES
      final imageCacheManager = ImageCacheManager();
      await imageCacheManager.cacheImages();

      // UPDATE THE ROOMS WITH THE LOCAL IMAGE PATHS
      final List<Future<Room>> updatedRoomsFromJson =
          await fileManager.readRoomsFromJsonFile();

      if (updatedRoomsFromJson.isNotEmpty) {
        return Future.wait(updatedRoomsFromJson).then((updatedRooms) {
          return updatedRooms.toList();
        });
      } else {
        return rooms.toList();
      }
    } else {
      throw Exception('Failed to load rooms');
    }
  }
}
