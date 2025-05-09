import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/features/favorites/presentation/block/favorites_event.dart';
import 'package:meal/features/meals/domain/repositories/favorites_repository.dart';
import 'package:meal/features/meals/domain/usecases/get_meal_details.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_event.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_state.dart';

class MealDetailBloc extends Bloc<MealDetailEvent, MealDetailState> {
  final GetMealDetails getMealDetails;
  final FavoritesRepository favoritesRepository;
  MealDetailBloc(this.getMealDetails, this.favoritesRepository) : super(MealDetailInitial()) {
    on<LoadMealDetail>((event, emit) async {
      emit(MealDetailLoading());
      try {
        final meal = await getMealDetails(event.id);
        final isLiked = await favoritesRepository.isFavorite(meal.idMeal ?? '');
        emit(MealDetailLoaded(meal, isLiked: isLiked));
      } catch (e) {
        emit(MealDetailError(e.toString()));
      }
    });

    on<SelectIngredientsTab>((event, emit) {
      if (state is MealDetailLoaded) {
        final currentState = state as MealDetailLoaded;
        emit(MealDetailLoaded(currentState.meal, isIngredientsSelected: true, isLiked: currentState.isLiked));
      }
    });

    on<SelectInstructionsTab>((event, emit) {
      if (state is MealDetailLoaded) {
        final currentState = state as MealDetailLoaded;
        emit(MealDetailLoaded(currentState.meal, isIngredientsSelected: false, isLiked: currentState.isLiked));
      }
    });

    on<ToggleLike>((event, emit) async {
      if (state is MealDetailLoaded) {
        final currentState = state as MealDetailLoaded;
        final isLiked = !currentState.isLiked;

        if (isLiked) {
          await favoritesRepository.saveFavorite(currentState.meal);
          emit(MealDetailToggleLike('Added to favorites'));
        } else {
          await favoritesRepository.removeFavorite(currentState.meal.idMeal ?? '');
          emit(MealDetailUnLike('${currentState.meal.strMeal} removed from favorites'));

          event.externalFavoritesEmiter?.call(FavoritesMealRemoved(currentState.meal));
        }

        emit(
          MealDetailLoaded(
            currentState.meal,
            isIngredientsSelected: currentState.isIngredientsSelected,
            isLiked: isLiked,
          ),
        );
      }
    });
  }
}
