import 'dart:async';

import 'package:aifer_machine_test/core/api/client.dart';
import 'package:aifer_machine_test/core/services/services.dart';
import 'package:aifer_machine_test/models/wallpaper_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallpaperViewmodel extends AsyncNotifier<List<WallpaperModel>>{
  
  WallpaperViewmodel(this.services);

   final Services services;

  @override
  FutureOr<List<WallpaperModel>> build() {
   return fetchData();
  }

  Future<List<WallpaperModel>> fetchData() async{
    try {
      
    final response = await services.getWallpapers();

    return response;



    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
}


final wallpaperProvider = AsyncNotifierProvider<WallpaperViewmodel, List<WallpaperModel>> (() {
  DioClient dioClient = DioClient();
  Services services = Services(dioClient: dioClient);
  return WallpaperViewmodel(services);
},);
