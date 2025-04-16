import 'package:meal/features/meals/domain/entities/meal.dart';
import 'package:meal/features/meals/domain/repositories/favorites_repository.dart';

class GetFavoriteMeals {
  final FavoritesRepository favoritesRepository;

  GetFavoriteMeals(this.favoritesRepository);

  Future<List<Meal>> call() async => await favoritesRepository.getFavorites();
}
