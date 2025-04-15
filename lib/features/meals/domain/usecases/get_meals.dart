import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/domain/repositories/meal_repository.dart';

class GetMeals {
  final MealRepository repository;

  GetMeals(this.repository);

  Future<List<Meal>> call() async => await repository.getMeals();
}
