import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          child: Column(children: [
            Text(t.menu),
            Row(
              children: <Widget>[
                Text(t.name),
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            client(t.age, t.name),
          ]),
        ),
      ),
    );
  }

  Widget client(String age, String name) {
    return Container(
      child: Column(
        children: [Text(name), Text(age), Text('Profession')],
      ),
    );
  }
}
