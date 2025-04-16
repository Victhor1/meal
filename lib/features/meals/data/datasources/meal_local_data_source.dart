import 'package:meal/core/local/favorites_local_storage.dart';

abstract class MealLocalDataSource {
  Future<List<String>> getFavorites();
  Future<void> saveFavorite(String mealId);
  Future<void> removeFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final FavoritesLocalStorage storage;

  MealLocalDataSourceImpl({required this.storage});

  @override
  Future<List<String>> getFavorites() => storage.getFavorites();

  @override
  Future<void> saveFavorite(String mealId) => storage.saveFavorite(mealId);

  @override
  Future<void> removeFavorite(String mealId) => storage.removeFavorite(mealId);

  @override
  Future<bool> isFavorite(String mealId) => storage.isFavorite(mealId);
}
