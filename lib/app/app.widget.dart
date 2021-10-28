import 'package:flutter/material.dart';
import 'package:mvp_proex/features/map/map.view.dart';
import 'package:mvp_proex/features/map/mapTest.view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/mapTest',
      routes: {
        '/map': (context) => const MapView(),
        '/mapTest': (context) => const MapTestView(),
      },
    );
  }
}
