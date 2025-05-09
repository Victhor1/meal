import 'package:meal/features/meals/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getMeals({String? search});
  Future<Meal> getMealDetails(String id);
}
