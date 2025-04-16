import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/injection_container.dart' as di;
import 'package:meal/core/routes/app_routes.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_event.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_event.dart';
import 'package:meal/features/meals/presentation/pages/meal_detail_page.dart';
import 'package:meal/features/meals/presentation/pages/meal_list_page.dart';
import 'package:meal/features/navigation/presentation/pages/main_navigation_page.dart';
import 'package:meal/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:meal/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage(), settings: settings);
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainNavigationPage(), settings: settings);
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage(), settings: settings);
      case AppRoutes.mealList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (_) => di.sl<MealBloc>()..add(LoadMeals()), child: const MealListPage()),
          settings: settings,
        );
      case AppRoutes.mealDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => di.sl<MealDetailBloc>()..add(LoadMealDetail(args['id'] as String)),
                child: const MealDetailPage(),
              ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('No route found'))),
          settings: settings,
        );
    }
  }
}
