import 'package:get_it/get_it.dart';
import 'package:meal/core/network/dio_client.dart';
import 'package:meal/features/meals/data/datasources/meal_local_data_source.dart';
import 'package:meal/features/meals/data/datasources/meal_remote_data_source.dart';
import 'package:meal/features/meals/data/repositories/favorites_repository_impl.dart';
import 'package:meal/features/meals/data/repositories/meal_repository.impl.dart';
import 'package:meal/features/meals/domain/repositories/favorites_repository.dart';
import 'package:meal/features/meals/domain/repositories/meal_repository.dart';
import 'package:meal/features/meals/domain/usecases/get_meal_details.dart';
import 'package:meal/features/meals/domain/usecases/get_meals.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_bloc.dart';

Future<void> initMeals(GetIt sl) async {
  // Blocs
  sl.registerFactory(() => MealBloc(sl()));
  sl.registerFactory(() => MealDetailBloc(sl<GetMealDetails>(), sl<FavoritesRepository>()));

  // Use cases
  sl.registerLazySingleton(() => GetMeals(sl()));
  sl.registerLazySingleton(() => GetMealDetails(sl()));

  // Repository
  sl.registerLazySingleton<MealRepository>(() => MealRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(localDataSource: sl()));

  // Data source
  sl.registerLazySingleton<MealRemoteDataSource>(() => MealRemoteDataSourceImpl(sl<DioClient>()));
  sl.registerLazySingleton<MealLocalDataSource>(() => MealLocalDataSourceImpl(storage: sl()));
}
