import 'package:dio/dio.dart';
import 'package:meal/features/meals/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMeals();
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
}
