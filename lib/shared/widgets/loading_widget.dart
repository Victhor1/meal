import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loadingWidget({String message = 'Cargando...'}) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/loading_animation.json', width: 100, fit: BoxFit.contain),
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
