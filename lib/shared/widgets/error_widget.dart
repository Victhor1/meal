import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal/core/theme/app_colors.dart';

Widget errorWidget({String message = 'Ocurrió un error, intenta de nuevo'}) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/error_animation.json', width: 300, height: 200, fit: BoxFit.contain),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
