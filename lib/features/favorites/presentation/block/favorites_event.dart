import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class FavoritesMealRemoved extends FavoritesEvent {
  final Meal meal;
  FavoritesMealRemoved(this.meal);
}
