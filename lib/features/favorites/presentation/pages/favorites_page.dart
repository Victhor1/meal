import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/routes/app_routes.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/features/favorites/presentation/block/favorites_bloc.dart';
import 'package:meal/features/favorites/presentation/block/favorites_state.dart';
import 'package:meal/shared/widgets/empty_widget.dart';
import 'package:meal/shared/widgets/error_widget.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';
import 'package:meal/shared/widgets/loading_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return switch (state) {
            FavoritesLoading() => loadingWidget(message: 'Loading favorites...'),
            FavoritesError() => errorWidget(message: 'Error loading favorites'),
            FavoritesEmpty() => emptyWidget(message: 'No favorites found'),
            FavoritesLoaded() => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    backgroundColor: AppColors.primary,
                    actions: [
                      IconButton(
                        icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isGridView = !_isGridView;
                          });
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          extendedImage(
                            imagePath:
                                'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: const Text(
                        'Mis Favoritos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Color.fromRGBO(0, 0, 0, 0.75))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverStack(
                      children: [
                        SliverAnimatedOpacity(
                          opacity: _isGridView ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final animation = CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                              );

                              final meal = state.meals[index];

                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.3),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.mealDetail,
                                        arguments: {
                                          'id': meal.idMeal,
                                          'image': meal.strMealThumb,
                                          'tag': 'favoriteGrid'
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Hero(
                                              tag: 'favoriteGrid-image-${meal.idMeal}',
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                                child: extendedImage(
                                                  imagePath: meal.strMealThumb ?? '',
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  meal.strMeal ?? '',
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                                    const SizedBox(width: 4),
                                                    Text('2', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                                    const Spacer(),
                                                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: state.meals.length),
                          ),
                        ),
                        SliverAnimatedOpacity(
                          opacity: _isGridView ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          sliver: SliverList.separated(
                            itemCount: state.meals.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final animation = CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                              );

                              final meal = state.meals[index];

                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.3),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.mealDetail,
                                        arguments: {
                                          'id': meal.idMeal,
                                          'image': meal.strMealThumb,
                                          'tag': 'favoriteList'
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Hero(
                                              tag: 'favoriteList-image-${meal.idMeal}',
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: extendedImage(
                                                  imagePath: meal.strMealThumb ?? '',
                                                  height: 70,
                                                  width: 70,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    meal.strMeal ?? '',
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                                      const SizedBox(width: 4),
                                                      Text('3',
                                                          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                                      const Spacer(),
                                                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
