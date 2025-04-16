import 'package:flutter/material.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen de fondo
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  extendedImage(
                    imagePath:
                        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                  ),
                ],
              ),
              title: const Text(
                'Mis Favoritos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Color.fromRGBO(0, 0, 0, 0.75))],
                ),
              ),
            ),
          ),

          // Lista de meals favoritas
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Aquí se usarían datos reales del share preferences
                final meals = [
                  {'name': 'Pasta Carbonara', 'rating': 4.5},
                  {'name': 'Ensalada César', 'rating': 4.0},
                  {'name': 'Pizza Margherita', 'rating': 5.0},
                  {'name': 'Salmón al Horno', 'rating': 4.8},
                  {'name': 'Tacos de Pollo', 'rating': 4.2},
                ];

                if (index >= meals.length) return null;

                final animation = CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                );

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(animation),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          meals[index]['name'] as String,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              meals[index]['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navegación a la página de detalle de la comida
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: 5, // Número de elementos en la lista
            ),
          ),
        ],
      ),
    );
  }
}
