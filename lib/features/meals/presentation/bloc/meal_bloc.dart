import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/features/meals/domain/usecases/get_meals.dart';
import 'package:meal/features/meals/presentation/bloc/meal_event.dart';
import 'package:meal/features/meals/presentation/bloc/meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final GetMeals getMeals;

  MealBloc(this.getMeals) : super(MealInitial()) {
    on<LoadMeals>((event, emit) async {
      emit(MealLoading());
      try {
        final meals = await getMeals();
        emit(MealLoaded(meals));
      } catch (e) {
        emit(MealError(e.toString()));
      }
    });
  }
}
