import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/hanoi.dart';
import 'view_models/hanoi_view_model.dart';
import 'views/hanoi_game_over_view.dart';
import 'views/hanoi_game_view.dart';
import 'views/game_config_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HanoiViewModel(Hanoi.classicGame()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Challenge Torre de Hanoi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/game',
      routes: {
        '/game': (context) => HanoiGameView(),
        '/level_config': (context) => GameConfigView(),
        '/game_over': (context) => HanoiGameOverView(),
      },
    );
  }
}
