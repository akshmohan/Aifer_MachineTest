import 'dart:developer';

import 'package:aifer_machine_test/viewModels/wallpaper_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    ref.read(wallpaperProvider.notifier).fetchWallpapers(); // Initial fetch
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(wallpaperProvider.notifier).fetchWallpapers(); // Load more
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallpapers = ref.watch(wallpaperProvider);

    return Scaffold(
      body: wallpapers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : MasonryGridView.builder(
              controller: _scrollController,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: wallpapers.length + 1, // Extra item for loader
              itemBuilder: (context, index) {
                if (index == wallpapers.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AspectRatio(
                  aspectRatio:
                      wallpapers[index].width / wallpapers[index].height,
                  child: GestureDetector(
                    onTap: () async {
                      bool res = await ref
                          .read(wallpaperProvider.notifier)
                          .download(wallpapers[index].links.download);
                      log(res.toString());
                    },
                    child: Image.network(wallpapers[index].urls.regular,
                        fit: BoxFit.cover),
                  ),
                );
              },
            ),
    );
  }
}
