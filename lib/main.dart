import 'package:flutter/material.dart';
import 'package:to_do/app/app.dart';
import 'package:to_do/app/di/di_injection.dart';

void main() {
  setUpDI(DIOptions.dev);
  runApp(const MyApp());
}
