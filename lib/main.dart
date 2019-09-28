import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_here/app.dart';
import 'package:preferences/preference_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await PrefService.init(prefix: 'pref_');
  runApp(App());
  SystemChrome.setEnabledSystemUIOverlays([]);
}
