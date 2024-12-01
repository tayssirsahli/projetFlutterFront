import 'package:flutter/material.dart';

import 'screen/classificationscreen.dart';
import 'screen/cosmetiquescreen.dart';
import 'screen/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/cosmetiques': (context) => CosmetiqueScreen(),
        '/classifications': (context) => ClassificationScreen(),

      },
    );
  }
}
