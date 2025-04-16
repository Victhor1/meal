import 'dart:math';

import 'package:meal/core/network/dio_client.dart';
import 'package:meal/features/meals/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMeals({String? search});
  Future<MealModel> getMealDetails(String id);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final DioClient _dioClient;

  MealRemoteDataSourceImpl(this._dioClient);

  int randomNumber() => Random().nextInt(100);

  @override
  Future<List<MealModel>> getMeals({String? search}) async {
    try {
      final String url =
          search != null
              ? 'https://www.themealdb.com/api/json/v1/1/search.php?s=$search'
              : 'https://www.themealdb.com/api/json/v1/1/search.php?s=';

      final response = await _dioClient.dio.get(url);
      if (response.statusCode == 200) {
        if (response.data['meals'] == null) return [];

        List<MealModel> meals = MealModel().fromJsonList(response.data['meals']);

        for (MealModel meal in meals) {
          meal.intViews = randomNumber();
          meal.intCalories = randomNumber();
          meal.intMinutes = randomNumber();
          meal.rating = randomNumber() / 10;
        }
        return meals;
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      throw Exception('Failed to load meals: $e');
    }
  }

  @override
  Future<MealModel> getMealDetails(String id) async {
    try {
      final response = await _dioClient.dio.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['meals'];
        MealModel meal = MealModel.fromJson(data.first);

        meal.intViews = randomNumber();
        meal.intCalories = randomNumber();
        meal.intMinutes = randomNumber();

        return meal;
      } else {
        throw Exception('Failed to load meal details');
      }
    } catch (e) {
      throw Exception('Failed to load meal details: $e');
    }
  }
}
