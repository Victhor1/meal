class Meal {
  String? idMeal;
  String? strMeal;
  String? strMealThumb;
  String? strCategory;
  String? strInstructions;
  String? strYoutube;
  int? intViews;
  int? intCalories;
  int? intMinutes;
  double? rating;
  List<String> ingredients;

  Meal({
    this.idMeal,
    this.strMeal,
    this.strMealThumb,
    this.strCategory,
    this.strInstructions,
    this.strYoutube,
    this.intViews,
    this.intCalories,
    this.intMinutes,
    this.rating,
    List<String>? ingredients,
  }) : ingredients = ingredients ?? [];

  void addIngredient(String? ingredient) {
    if (ingredient != null && ingredient.isNotEmpty) {
      ingredients.add(ingredient);
    }
  }
}
