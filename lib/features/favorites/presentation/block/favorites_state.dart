import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Meal> meals;
  FavoritesLoaded(this.meals);
}

class FavoritesEmpty extends FavoritesState {}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}
