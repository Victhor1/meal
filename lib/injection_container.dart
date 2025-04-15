import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meal/features/meals/data/datasources/meal_remote_data_source.dart';
import 'package:meal/features/meals/data/repositories/meal_repository.impl.dart';
import 'package:meal/features/meals/domain/repositories/meal_repository.dart';
import 'package:meal/features/meals/domain/usecases/get_meals.dart';
import 'package:meal/features/meals/presentation/bloc/meal_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => MealBloc(sl()));
  sl.registerLazySingleton(() => GetMeals(sl()));
  sl.registerLazySingleton<MealRepository>(() => MealRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<MealRemoteDataSource>(() => MealRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton(() => Dio());
}
