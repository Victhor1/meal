# Meal App 🍗

Una aplicación moderna de recetas desarrollada con Flutter que te permite explorar, buscar y guardar tus comidas favoritas.

## Características ✨

- 🔍 Búsqueda de recetas en tiempo real
- ❤️ Sistema de favoritos
- 🎨 Interfaz moderna y animada
- 📱 Diseño responsive
- 🌙 Soporte para modo oscuro (próximamente)
- 🎬 Integración con YouTube para ver tutoriales
- 📊 Estadísticas de recetas
- 🔄 Sincronización en tiempo real

## Capturas de Pantalla 📱

<div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
    <img src="assets/ss/Simulator Screenshot - iPhone 16 Pro Max - 2025-04-16 at 18.01.54.png" width="200" alt="Lista de Comidas"/>
    <img src="assets/ss/Simulator Screenshot - iPhone 16 Pro Max - 2025-04-16 at 18.02.03.png" width="200" alt="Detalle de Comida"/>
    <img src="assets/ss/Simulator Screenshot - iPhone 16 Pro Max - 2025-04-16 at 18.02.08.png" width="200" alt="Favoritos Grid"/>
    <img src="assets/ss/Simulator Screenshot - iPhone 16 Pro Max - 2025-04-16 at 18.02.14.png" width="200" alt="Favoritos Lista"/>
    <img src="assets/ss/Simulator Screenshot - iPhone 16 Pro Max - 2025-04-16 at 18.02.19.png" width="200" alt="Búsqueda"/>
</div>

## Tecnologías Utilizadas 🛠️

- Flutter 3.x
- Bloc para gestión de estado
- Clean Architecture
- Dio para peticiones HTTP
- GetIt para inyección de dependencias
- SharedPreferences para almacenamiento local

## Arquitectura 🏗️

La aplicación sigue los principios de Clean Architecture con una estructura de tres capas:

```
lib/
├── core/              # Utilidades y configuraciones core
├── features/          # Módulos de la aplicación
│   ├── meals/        # Feature de comidas
│   └── favorites/    # Feature de favoritos
└── shared/           # Widgets y utilidades compartidas
```

## Instalación 🚀

1. Clona el repositorio:
```bash
git clone https://github.com/yourusername/meal-app.git
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## Contribución 🤝

Las contribuciones son bienvenidas. Por favor:

1. Haz Fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia 📄

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
