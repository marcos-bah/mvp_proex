import 'package:flutter/material.dart';
import 'package:mvp_proex/features/map/map.view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVP Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.black26,
      ),
      initialRoute: '/map',
      routes: {
        '/map': (context) => const MapView(),
      },
    );
  }
}
