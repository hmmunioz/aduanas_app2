import 'package:aduanas_app/src/constants/services_url.dart';
import 'package:flutter/material.dart';

import 'app_config.dart';
class ConstantsApp extends InheritedWidget {
  static ConstantsApp of(BuildContext context) => context. dependOnInheritedWidgetOfExactType<ConstantsApp>();

   ConstantsApp({Widget child, Key key}): super(key: key, child: child);

  final appConfig=  new AppConfig();
  final urlServices= new UrlServices();
  
  @override
  bool updateShouldNotify(ConstantsApp oldWidget) => false;
    /* ConstantsApp(); */
}