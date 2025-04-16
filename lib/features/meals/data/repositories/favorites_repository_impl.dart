import 'package:meal/features/meals/data/datasources/meal_local_data_source.dart';
import 'package:meal/features/meals/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final MealLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<String>> getFavorites() => localDataSource.getFavorites();

  @override
  Future<void> saveFavorite(String mealId) => localDataSource.saveFavorite(mealId);

  @override
  Future<void> removeFavorite(String mealId) => localDataSource.removeFavorite(mealId);

  @override
  Future<bool> isFavorite(String mealId) => localDataSource.isFavorite(mealId);
}
