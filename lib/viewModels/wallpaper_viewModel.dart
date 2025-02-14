import 'package:aifer_machine_test/core/api/client.dart';
import 'package:aifer_machine_test/core/services/services.dart';
import 'package:aifer_machine_test/models/wallpaper_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallpaperViewmodel extends AsyncNotifier<List<WallpaperModel>> {
  WallpaperViewmodel(this.services);

  final Services services;

  int pageCount = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isInitalised = true;

  @override
  Future<List<WallpaperModel>> build() async {
    return fetchData(isInitialLoad: true);


  }



Future<List<WallpaperModel>> fetchData({bool isInitialLoad = false}) async {
  if (!hasMore || isLoading) return state.value ?? []; // Stop if already loading or no more data

  isLoading = true;
  try {
    final response = await services.getWallpapers(pageCount);

    // Explicitly cast response to List<WallpaperModel>
    final List<WallpaperModel> wallpaperList = response.cast<WallpaperModel>();

    if (wallpaperList.isEmpty) {
      hasMore = false; // No more wallpapers to load
    } else {
      pageCount++; // Increase page count for the next request
    }

    final updatedList = isInitalised ? wallpaperList : [...state.value ?? [], ...wallpaperList];

    return wallpaperList;
  } catch (e) {
    state = AsyncError(e.toString(), StackTrace.current);
    return state.value ?? [];
  } finally {
    isLoading = false;
  }
}
}

final wallpaperProvider = AsyncNotifierProvider<WallpaperViewmodel, List<WallpaperModel>>(() {
  DioClient dioClient = DioClient();
  Services services = Services(dioClient: dioClient);
  return WallpaperViewmodel(services);
});