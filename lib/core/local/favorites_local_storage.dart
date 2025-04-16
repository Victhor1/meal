import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalStorage {
  static const _key = 'favorite_meal_ids';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> saveFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      await prefs.setStringList(_key, favorites);
    }
  }

  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    favorites.remove(mealId);
    await prefs.setStringList(_key, favorites);
  }

  Future<bool> isFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    return favorites.contains(mealId);
  }
}
