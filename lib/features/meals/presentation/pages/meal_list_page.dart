import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/routes/app_routes.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_state.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';

class MealListPage extends StatelessWidget {
  const MealListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍗 Meal App', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        surfaceTintColor: AppColors.primary,
      ),
      body: SafeArea(
        child: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            return switch (state) {
              MealLoading() => const Center(child: CircularProgressIndicator()),
              MealLoaded() => ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.meals.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  Meal meal = state.meals[index];
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite_border),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              MealError() => Center(child: Text(state.message)),
              _ => const Center(child: Text('No meals found')),
            };
          },
        ),
      ),
    );
  }
}
