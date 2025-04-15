import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/domain/repositories/meal_repository.dart';

class GetMealDetails {
  final MealRepository repository;

  GetMealDetails(this.repository);

  Future<Meal> call(String id) async => await repository.getMealDetails(id);
}
