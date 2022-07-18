import 'package:flutter/material.dart';
import 'package:mvp_proex/app/app.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  runApp(const AppWidget());
}
