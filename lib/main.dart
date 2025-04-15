import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/theme/app_theme.dart';
import 'package:meal/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/meal_event.dart';
import 'package:meal/features/meals/presentation/pages/meal_list_page.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App',
      theme: AppTheme.lightTheme,
      home: BlocProvider(create: (_) => di.sl<MealBloc>()..add(LoadMeals()), child: const MealListPage()),
    );
  }
}
