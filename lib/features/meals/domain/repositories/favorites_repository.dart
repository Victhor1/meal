abstract class FavoritesRepository {
  Future<List<String>> getFavorites();
  Future<void> saveFavorite(String mealId);
  Future<void> removeFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
}
