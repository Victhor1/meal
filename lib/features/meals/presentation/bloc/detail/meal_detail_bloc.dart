import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/features/meals/domain/usecases/get_meal_details.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_event.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_state.dart';

class MealDetailBloc extends Bloc<MealDetailEvent, MealDetailState> {
  final GetMealDetails getMealDetails;

  MealDetailBloc(this.getMealDetails) : super(MealDetailInitial()) {
    on<LoadMealDetail>((event, emit) async {
      emit(MealDetailLoading());
      try {
        final meal = await getMealDetails(event.id);
        emit(MealDetailLoaded(meal));
      } catch (e) {
        emit(MealDetailError(e.toString()));
      }
    });
  }
}
