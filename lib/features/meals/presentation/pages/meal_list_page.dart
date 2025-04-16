import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/routes/app_routes.dart';
import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_event.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_state.dart';
import 'package:meal/shared/widgets/empty_widget.dart';
import 'package:meal/shared/widgets/error_widget.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';

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
          child:
              _isSearching
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
                MealLoading() => const Center(child: CircularProgressIndicator()),
                MealLoaded() =>
                  state.meals.isEmpty
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
      onTap:
          () => Navigator.pushNamed(
            context,
            AppRoutes.mealDetail,
            arguments: {'id': meal.idMeal, 'image': meal.strMealThumb},
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Hero(
                tag: 'meal-image-${meal.idMeal}',
                child: extendedImage(imagePath: meal.strMealThumb ?? '', height: 300),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(40)),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.strMeal?.toUpperCase() ?? '',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            meal.strCategory ?? '',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
