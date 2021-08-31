import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:language/screens/detailProduct.dart';
import 'package:language/screens/hero_list.dart';
import 'package:language/screens/home.dart';
import 'package:language/screens/mapScreen.dart';
import 'package:language/screens/menu.dart';
import 'package:language/screens/set_param.dart';
import 'package:language/screens/sqllite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context).appTitle;
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
        const Locale('ar', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.red,

      ),
      initialRoute: '/menu',
      routes: {
        '/': (context) {
          return HeroList(title: AppLocalizations.of(context).appTitle);
        },
        '/home' : (context) => Home(),
        '/menu' : (context) => MenuScreen(),
        '/settings' : (context) => Settings(),
        '/maps' : (context) => MapScreen(),
        '/detailProduct' : (context) => DetailProduct(),
        '/sqlLite' : (context) => SqlLiteScreen(),

      },

    );
  }
}
