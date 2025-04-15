import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meal/features/meals/di/injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  await initMeals(sl);

  // External
  sl.registerLazySingleton(() => Dio());
}
