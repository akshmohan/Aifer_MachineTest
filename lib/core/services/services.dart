import 'package:aifer_machine_test/core/api/client.dart';
import 'package:aifer_machine_test/models/wallpaper_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Services {
  Services({required this.dioClient});

  final DioClient dioClient;

  Future<List<WallpaperModel>> getWallpapers() async {
    try {
      final response = await dioClient.get("/photos", queryParams: {
        "client_id": dotenv.env["ACCESS_KEY"],
        "page": 1,
        "per_page": 10,
      });

      if (response != null && response.statusCode == 200) {
        debugPrint("Fetched wallpapers:  ${response.statusCode}");
        return wallpaperModelFromJson(response.data);
      } else {
        debugPrint(
            "Failed to fetch wallpapers. Status: ${response?.statusCode}");
            throw Exception();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
