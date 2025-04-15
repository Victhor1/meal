import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_state.dart';

class MealDetailPage extends StatelessWidget {
  const MealDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Detail')),
      body: SafeArea(
        child: BlocBuilder<MealDetailBloc, MealDetailState>(
          builder: (context, state) {
            return switch (state) {
              MealDetailLoading() => const Center(child: CircularProgressIndicator()),
              MealDetailLoaded() => Center(child: Text(state.meal.strMeal ?? '')),
              MealDetailError() => Center(child: Text(state.message)),
              _ => const Center(child: Text('No meal detail found')),
            };
          },
        ),
      ),
    );
  }
}
