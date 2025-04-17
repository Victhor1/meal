import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/injection_container.dart' as di;
import 'package:meal/features/favorites/presentation/block/favorites_bloc.dart';
import 'package:meal/features/favorites/presentation/block/favorites_event.dart';
import 'package:meal/features/favorites/presentation/pages/favorites_page.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/list/meal_event.dart';
import 'package:meal/features/meals/presentation/pages/meal_list_page.dart';
import 'package:meal/features/profile/presentation/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BlocProvider(create: (_) => di.sl<MealBloc>()..add(LoadMeals()), child: const MealListPage()),
    BlocProvider(create: (_) => di.sl<FavoritesBloc>()..add(LoadFavorites()), child: const FavoritesPage()),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Meals'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}
