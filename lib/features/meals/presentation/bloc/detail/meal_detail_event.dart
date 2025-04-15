abstract class MealDetailEvent {}

class LoadMealDetail extends MealDetailEvent {
  final String id;
  LoadMealDetail(this.id);
}
