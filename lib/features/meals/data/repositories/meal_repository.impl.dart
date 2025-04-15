import 'package:meal/features/meals/data/datasources/meal_remote_data_source.dart';
import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/domain/repositories/meal_repository.dart';

class MealRepositoryImpl extends MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Meal>> getMeals() async => await remoteDataSource.getMeals();

  @override
  Future<Meal> getMealDetails(String id) async => await remoteDataSource.getMealDetails(id);
}
