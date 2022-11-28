import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:dd_study_22_ui/ui/roots/loader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: AppNavigator.key,
      onGenerateRoute: (settings) => AppNavigator.onGenerateRoute(settings, context),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoaderWidget.create(),
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
