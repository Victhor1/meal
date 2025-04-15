abstract class MealDetailEvent {}

class LoadMealDetail extends MealDetailEvent {
  final String id;
  LoadMealDetail(this.id);
}

class SelectIngredientsTab extends MealDetailEvent {}

class SelectInstructionsTab extends MealDetailEvent {}
