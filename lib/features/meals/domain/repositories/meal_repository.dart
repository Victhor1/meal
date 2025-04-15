import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getMeals();
  Future<Meal> getMealDetails(String id);
}
