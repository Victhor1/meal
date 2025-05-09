abstract class MealDetailEvent {}

class LoadMealDetail extends MealDetailEvent {
  final String id;
  LoadMealDetail(this.id);
}

class SelectIngredientsTab extends MealDetailEvent {}

class SelectInstructionsTab extends MealDetailEvent {}

class OpenYoutubeVideo extends MealDetailEvent {}

class ToggleLike extends MealDetailEvent {
  final void Function(dynamic state)? externalFavoritesEmiter;
  ToggleLike({this.externalFavoritesEmiter});
}
