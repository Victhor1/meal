import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meal/core/local/favorites_local_storage.dart';
import 'package:meal/core/network/dio_client.dart';
import 'package:meal/features/favorites/di/injection_container.dart';
import 'package:meal/features/meals/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // Local
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<FavoritesLocalStorage>(() => FavoritesLocalStorage());

  // Features
  await initMeals(sl);
  await initFavorites(sl);
}
