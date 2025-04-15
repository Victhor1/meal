import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class MealDetailState {}

class MealDetailInitial extends MealDetailState {}

class MealDetailLoading extends MealDetailState {}

class MealDetailLoaded extends MealDetailState {
  final Meal meal;
  final bool isIngredientsSelected;

  MealDetailLoaded(this.meal, {this.isIngredientsSelected = true});
}

class MealDetailError extends MealDetailState {
  final String message;

  MealDetailError(this.message);
}
