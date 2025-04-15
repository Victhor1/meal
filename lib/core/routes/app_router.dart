import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/routes/app_routes.dart';
import 'package:meal/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/meal_event.dart';
import 'package:meal/features/meals/presentation/pages/meal_list_page.dart';
import 'package:meal/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:meal/injection_container.dart' as di;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage(), settings: settings);
      case AppRoutes.mealList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => di.sl<MealBloc>()..add(LoadMeals()), child: const MealListPage()),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingPage(), settings: settings);
    }
  }
}
