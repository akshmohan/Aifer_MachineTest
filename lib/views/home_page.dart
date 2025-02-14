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
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      ref.read(wallpaperProvider.notifier).fetchData();
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
    final wallpaperListed = ref.watch(wallpaperProvider);

    return Scaffold(
      body: wallpaperListed.when(
        data: (data) {
          return MasonryGridView.builder(
            controller: _scrollController,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: data.length + 1, // Extra item for loading indicator
            itemBuilder: (context, index) {
              if (index == data.length) {
                return ref.read(wallpaperProvider.notifier).hasMore
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              return AspectRatio(
                aspectRatio: data[index].width / data[index].height,
                child: Image.network(data[index].urls.regular, fit: BoxFit.cover),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}