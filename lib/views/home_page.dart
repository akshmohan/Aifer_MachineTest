import 'package:aifer_machine_test/viewModels/wallpaper_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallpaperListed = ref.watch(wallpaperProvider);
    return Scaffold(
      body: wallpaperListed.when(
        data: (data) {
          return MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Image.network(data[index].urls.regular);
            },
          );
        },
        error: (error, stackTrace) {},
        loading: () {
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
