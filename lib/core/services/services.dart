import 'dart:convert';
import 'dart:developer';

import 'package:aifer_machine_test/core/api/client.dart';
import 'package:aifer_machine_test/models/wallpaper_model.dart';
import 'package:flutter/material.dart';

class Services {
  Services({required this.dioClient});

  final DioClient dioClient;

  Future<List<WallpaperModel>> getWallpapers() async {
    try {
      final response = await dioClient.get("/photos", queryParams: {
        "client_id": "QRuE-fanwJWNJ7LUrbbz__q6hijXHElqlpkYS2oYbiU",
        "page": 1,
        "per_page": 10,
      });

      if (response != null && response.statusCode == 200) {
        log("Fetched wallpapers:  ${response.data}", name: "ERRORRR");
        return wallpaperModelFromJson(jsonEncode(response.data));
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
