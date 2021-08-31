import 'package:flutter/material.dart';
import 'package:language/screens/set_param.dart';
import 'package:language/widgets/hero_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeroList extends StatelessWidget {
  final String title;

  const HeroList({this.title});

  @override
  Widget build(BuildContext context) {
    Locale activeLocale = Localizations.localeOf(context);
// If our active locale is fr_CA
    debugPrint(activeLocale.languageCode); // => fr
    debugPrint(activeLocale.countryCode); // => CA
    var t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              tooltip: t.openSettings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(t.heroCount(6)),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  HeroCard(
                    name: 'Grace Hopper',
                    born: '9 December 1906',
                    bio: t.wozniakBio('Apple I', 'Apple II'),
                    imagePath: 'assets/images/Grace_Hopper.jpg',
                  ),
                  HeroCard(
                    name: 'Alan Turing',
                    born: '23 June 1912',
                    bio: 'Father of theoretical computer science & '
                        'artificial intelligence.',
                    imagePath: 'assets/images/Grace_Hopper.jpg',
                  ),

                  // ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
