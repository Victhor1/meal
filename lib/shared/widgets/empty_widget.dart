import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget emptyWidget({String message = 'Ocurrió un error, intenta de nuevo'}) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/empty_animation.json', width: 300, fit: BoxFit.contain),
          SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
