import 'package:get_it/get_it.dart';
import 'package:meal/core/repositories/favorites_repository_impl.dart';
import 'package:meal/features/favorites/domain/usecases/get_favorite_meals.dart';
import 'package:meal/features/favorites/presentation/block/favorites_bloc.dart';
import 'package:meal/features/meals/domain/repositories/favorites_repository.dart';

Future<void> initFavorites(GetIt sl) async {
  // Bloc
  sl.registerFactory(() => FavoritesBloc(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetFavoriteMeals(sl()));

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(localDataSource: sl()));
}
