import 'package:meal/features/meals/domain/entities/meal.dart';

class MealModel extends Meal {
  MealModel({super.idMeal, super.strMeal, super.strMealThumb, super.strCategory});

  MealModel.fromJson(Map<String, dynamic> json) {
    idMeal = json['idMeal'];
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
    strCategory = json['strCategory'];
  }
}
