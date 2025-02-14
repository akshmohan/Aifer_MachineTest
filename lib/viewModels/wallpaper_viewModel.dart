import 'package:aifer_machine_test/core/api/client.dart';
import 'package:aifer_machine_test/core/download_service.dart';
import 'package:aifer_machine_test/core/services/services.dart';
import 'package:aifer_machine_test/models/wallpaper_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final wallpaperProvider =
    StateNotifierProvider<WallpaperNotifier, List<WallpaperModel>>((ref) {
  return WallpaperNotifier();
});

class WallpaperNotifier extends StateNotifier<List<WallpaperModel>> {
  WallpaperNotifier() : super([]);

  int _page = 1;
  bool _isFetching = false;

  Future<void> fetchWallpapers() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final newWallpapers =
          await Services(dioClient: DioClient()).getWallpapers(_page);

      if (newWallpapers.isNotEmpty) {
        state = [...state, ...newWallpapers]; // Append new data
        _page++;
      }
    } catch (e) {
      debugPrint("Error fetching wallpapers: $e");
    }

    _isFetching = false;
  }


  Future<bool> download(String imageUrl) async{
    try {
      String folderPath = await downloadFolder() ?? "";
       if (folderPath.isEmpty) {
       
        return false;
      }
        bool res = await Services(dioClient: DioClient()).downloadImage(imageUrl, folderPath);
      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}