import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/item_model.dart';

// coverage:ignore-file

class ItemService {
  final String baseUrl;

  ItemService(this.baseUrl);

  Future<Item> fetchItem(int id) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/items/$id')); // RÉCUPÈRE L'ITEM AVEC L'ID SPÉCIFIÉ

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Item.fromJson(data);
    } else {
      throw Exception('Failed to load item');
    }
  }
}
