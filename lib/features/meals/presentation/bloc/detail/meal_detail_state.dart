import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class MealDetailState {}

class MealDetailInitial extends MealDetailState {}

class MealDetailLoading extends MealDetailState {}

class MealDetailLoaded extends MealDetailState {
  final Meal meal;
  final bool isIngredientsSelected;
  final bool isLiked;

  MealDetailLoaded(this.meal, {this.isIngredientsSelected = true, this.isLiked = false});
}

class MealDetailError extends MealDetailState {
  final String message;

  MealDetailError(this.message);
}

class MealDetailToggleLike extends MealDetailState {
  final String message;

  MealDetailToggleLike(this.message);
}

class MealDetailUnLike extends MealDetailState {
  final String message;

  MealDetailUnLike(this.message);
}
