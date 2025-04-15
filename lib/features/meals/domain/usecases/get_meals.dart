import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/domain/repositories/meal_repository.dart';

class GetMeals {
  final MealRepository repository;

  GetMeals(this.repository);

  Future<List<Meal>> call({String? search}) async => await repository.getMeals(search: search);
}
