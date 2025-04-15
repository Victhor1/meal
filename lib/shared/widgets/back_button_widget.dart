import 'package:flutter/material.dart';

Widget backButtonWidget() => Container(
  decoration: BoxDecoration(
    color: Colors.white60,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey),
  ),
  padding: EdgeInsets.zero,
  margin: EdgeInsets.symmetric(horizontal: 10),
  child: BackButton(color: Colors.black),
);
