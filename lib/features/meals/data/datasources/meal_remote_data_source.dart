import 'package:dio/dio.dart';
import 'package:meal/features/meals/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMeals();
  Future<MealModel> getMealDetails(String id);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final Dio dio;

  MealRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MealModel>> getMeals() async {
    try {
      final response = await dio.get('https://www.themealdb.com/api/json/v1/1/search.php?s=');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['meals'];
        return data.map((meal) => MealModel.fromJson(meal)).toList();
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
      final response = await dio.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['meals'];
        return MealModel.fromJson(data.first);
      } else {
        throw Exception('Failed to load meal details');
      }
    } catch (e) {
      throw Exception('Failed to load meal details: $e');
    }
  }
}
