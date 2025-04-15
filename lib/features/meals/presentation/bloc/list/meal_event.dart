abstract class MealEvent {}

class LoadMeals extends MealEvent {
  final String? search;
  LoadMeals({this.search});
}
