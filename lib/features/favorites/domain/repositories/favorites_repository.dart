import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class FavoritesRepository {
  Future<List<Meal>> getFavorites();
  Future<void> saveFavorite(Meal meal);
  Future<void> removeFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
}
