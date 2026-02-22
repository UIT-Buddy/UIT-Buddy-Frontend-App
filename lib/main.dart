import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/app.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MainApp());
}
