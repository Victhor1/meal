import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/meal_state.dart';

class MealListPage extends StatelessWidget {
  const MealListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal App')),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          if (state is MealLoading) return const Center(child: CircularProgressIndicator());
          if (state is MealLoaded) {
            return ListView.builder(
              itemCount: state.meals.length,
              itemBuilder: (context, index) {
                final meal = state.meals[index];
                return ListTile(title: Text(meal.strMeal ?? 'NAME'), subtitle: Text(meal.idMeal ?? 'ID'));
              },
            );
          }
          if (state is MealError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No meals found'));
        },
      ),
    );
  }
}
