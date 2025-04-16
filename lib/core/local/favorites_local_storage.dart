import 'dart:convert';

import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalStorage {
  static const _key = 'favorite_meals';

  Future<List<Meal>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = prefs.getStringList(_key) ?? [];
    return mealsJson.map((mealStr) => _mealFromJson(mealStr)).toList();
  }

  Future<void> saveFavorite(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = prefs.getStringList(_key) ?? [];

    // Verificar si meal ya existe
    final exists = mealsJson.any((mealStr) {
      final existingMeal = _mealFromJson(mealStr);
      return existingMeal.idMeal == meal.idMeal;
    });

    if (!exists) {
      mealsJson.add(_mealToJson(meal));
      await prefs.setStringList(_key, mealsJson);
    }
  }

  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = prefs.getStringList(_key) ?? [];

    mealsJson.removeWhere((mealStr) {
      final meal = _mealFromJson(mealStr);
      return meal.idMeal == mealId;
    });

    await prefs.setStringList(_key, mealsJson);
  }

  Future<bool> isFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = prefs.getStringList(_key) ?? [];
    return mealsJson.any((mealStr) {
      final meal = _mealFromJson(mealStr);
      return meal.idMeal == mealId;
    });
  }

  String _mealToJson(Meal meal) {
    final Map<String, dynamic> mealMap = {
      'idMeal': meal.idMeal,
      'strMeal': meal.strMeal,
      'strMealThumb': meal.strMealThumb,
      'strYoutube': meal.strYoutube,
    };
    return jsonEncode(mealMap);
  }

  Meal _mealFromJson(String jsonStr) {
    final Map<String, dynamic> mealMap = jsonDecode(jsonStr);
    return Meal(
      idMeal: mealMap['idMeal'],
      strMeal: mealMap['strMeal'],
      strMealThumb: mealMap['strMealThumb'],
      strYoutube: mealMap['strYoutube'],
    );
  }
}
