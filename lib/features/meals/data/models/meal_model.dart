import 'package:meal/features/meals/domain/entities/meal.dart';

class MealModel extends Meal {
  MealModel({
    super.idMeal,
    super.strMeal,
    super.strMealThumb,
    super.strCategory,
    super.strInstructions,
    super.intViews,
    super.intCalories,
    super.intMinutes,
    super.strYoutube,
    super.rating,
  });

  MealModel.fromJson(Map<String, dynamic> json) {
    idMeal = json['idMeal'];
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
    strCategory = json['strCategory'];
    strInstructions = json['strInstructions'];
    strYoutube = json['strYoutube'];
    intViews = json['intViews'];
    intCalories = json['intCalories'];
    intMinutes = json['intMinutes'];
    rating = json['rating'];
    // Agregar ingredientes a la lista porque no viene en lista
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        addIngredient(ingredient.toString());
      }
    }
  }

  List<MealModel> fromJsonList(List<dynamic> jsonList) => jsonList.map((json) => MealModel.fromJson(json)).toList();
}
