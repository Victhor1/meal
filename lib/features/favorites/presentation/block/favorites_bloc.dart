import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/utils/logger.dart';
import 'package:meal/features/favorites/domain/usecases/get_favorite_meals.dart';
import 'package:meal/features/favorites/presentation/block/favorites_event.dart';
import 'package:meal/features/favorites/presentation/block/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteMeals getFavoriteMeals;

  FavoritesBloc(this.getFavoriteMeals) : super(FavoritesInitial()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final meals = await getFavoriteMeals();

        if (meals.isEmpty) {
          emit(FavoritesEmpty());
          return;
        }

        emit(FavoritesLoaded(meals));
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    });

    on<FavoritesMealRemoved>((event, emit) async {
      if (state is FavoritesLoaded) {
        Logger().i('FavoritesMealRemoved', tag: 'FavoritesBloc');
        Logger().i('TO REMOVE: ${event.meal.strMeal}', tag: 'FavoritesBloc');

        //final currentState = state as FavoritesLoaded;
        //final updatedMeals = currentState.meals.where((meal) => meal.idMeal != event.meal.idMeal).toList();

        final meals = await getFavoriteMeals();

        if (meals.isEmpty) {
          emit(FavoritesEmpty());
          return;
        }

        emit(FavoritesLoaded(meals));
      }
    });
  }
}
