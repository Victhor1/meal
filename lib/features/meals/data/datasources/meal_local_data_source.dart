import 'package:meal/core/local/favorites_local_storage.dart';
import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class MealLocalDataSource {
  Future<List<Meal>> getFavorites();
  Future<void> saveFavorite(Meal meal);
  Future<void> removeFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final FavoritesLocalStorage storage;

  MealLocalDataSourceImpl({required this.storage});

  @override
  Future<List<Meal>> getFavorites() => storage.getFavorites();

  @override
  Future<void> saveFavorite(Meal meal) => storage.saveFavorite(meal);

  @override
  Future<void> removeFavorite(String mealId) => storage.removeFavorite(mealId);

  @override
  Future<bool> isFavorite(String mealId) => storage.isFavorite(mealId);
}
