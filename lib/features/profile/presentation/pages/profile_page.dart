import 'package:flutter/material.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen de fondo
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
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
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
              title: const Text(
                'Mi Perfil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Color.fromRGBO(0, 0, 0, 0.75))],
                ),
              ),
            ),
          ),

          // Contenido del perfil
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar y nombre
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
                        ),
                        const SizedBox(height: 16),
                        const Text('María García', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('maria.garcia@email.com', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatItem('Recetas', '42'),
                            _buildDivider(),
                            _buildStatItem('Favoritos', '18'),
                            _buildDivider(),
                            _buildStatItem('Seguidores', '256'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sección de estadísticas
                  const Text('Estadísticas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildStatsCard(),

                  const SizedBox(height: 32),

                  // Sección de preferencias
                  const Text('Preferencias', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildPreferencesCard(),

                  const SizedBox(height: 32),

                  // Sección de actividad reciente
                  const Text('Actividad Reciente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRecentActivityCard(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 24, width: 1, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 16));
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatRow('Comidas guardadas', '24'),
            const Divider(),
            _buildStatRow('Comidas compartidas', '8'),
            const Divider(),
            _buildStatRow('Comentarios', '32'),
            const Divider(),
            _buildStatRow('Tiempo en la app', '48 horas'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPreferenceRow('Notificaciones', true),
            const Divider(),
            _buildPreferenceRow('Modo oscuro', false),
            const Divider(),
            _buildPreferenceRow('Idioma', 'Español'),
            const Divider(),
            _buildPreferenceRow('Unidades', 'Métrico'),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          if (value is bool)
            Switch(value: value, onChanged: (newValue) {}, activeColor: AppColors.primary)
          else
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildActivityItem('Pasta Carbonara', 'Guardaste esta receta', 'Hace 2 horas', Icons.bookmark),
            const Divider(),
            _buildActivityItem('Ensalada César', 'Compartiste esta receta', 'Hace 1 día', Icons.share),
            const Divider(),
            _buildActivityItem('Pizza Margherita', 'Comentaste en esta receta', 'Hace 3 días', Icons.comment),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String description, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
