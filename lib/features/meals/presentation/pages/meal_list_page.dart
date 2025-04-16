import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/routes/app_routes.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_event.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_state.dart';
import 'package:meal/shared/widgets/empty_widget.dart';
import 'package:meal/shared/widgets/error_widget.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';
import 'package:meal/shared/widgets/loading_widget.dart';

class MealListPage extends StatefulWidget {
  const MealListPage({super.key});

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    context.read<MealBloc>().add(LoadMeals());
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MealBloc>().add(LoadMeals(search: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            );
          },
          child: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Search meals...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: _onSearchChanged,
                )
              : const Text('🍗 Meal App', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<MealBloc>().add(LoadMeals());
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocListener<MealBloc, MealState>(
          listener: (context, state) {
            if (state is MealLoaded) {
              _animationController.reset();
              _animationController.forward();
            }
          },
          child: BlocBuilder<MealBloc, MealState>(
            builder: (context, state) {
              return switch (state) {
                MealLoading() => loadingWidget(message: 'Loading meals...'),
                MealLoaded() => state.meals.isEmpty
                    ? emptyWidget(message: 'No meals found')
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<MealBloc>().add(LoadMeals());
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: state.meals.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final animation = CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                            );

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.3),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: _buildMealCard(state.meals[index]),
                              ),
                            );
                          },
                        ),
                      ),
                MealError() => Center(child: errorWidget(message: state.message)),
                _ => const Center(child: Text('No meals found')),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.mealDetail,
        arguments: {'id': meal.idMeal, 'image': meal.strMealThumb, 'tag': 'list'},
      ),
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Stack(
          children: [
            // Imagen de fondo con efecto de gradiente
            Hero(
              tag: 'list-image-${meal.idMeal}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    extendedImage(imagePath: meal.strMealThumb ?? '', height: double.infinity, width: double.infinity),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenido superpuesto
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Categoría
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        meal.strCategory ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Nombre de la comida
                    Text(
                      meal.strMeal ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Información adicional
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text('${meal.intMinutes} min', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(width: 16),
                        const Icon(Icons.remove_red_eye, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text('${meal.intViews} views', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Botón de favorito
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${meal.rating}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
