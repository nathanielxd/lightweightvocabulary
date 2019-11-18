import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:lightweightvocabularypro/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OptionsPage extends StatefulWidget {

  OptionsPage({Key key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

  @override
  void dispose() {
    super.dispose();

    saveSettings();
  }

  void saveSettings() async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('sortingType', Data.sortingType);
      prefs.setBool('saveAfterAdding', Data.saveAfterAdding);
      prefs.setBool('saveAfterDeleting', Data.saveAfterDeleting);
    });
  }

  String _getSortingType() {
    switch(Data.sortingType) {
      case 0:
        return 'none';
        break;
      case 1:
        return 'alphabetically';
        break;
      case 2:
        return 'by size';
        break;
      case 3:
        return 'by time added';
        break;
      default:
        return 'error-no-sort-type';
        break;
    }
  }

  void _launchUrl(String url) async {
    if(await canLaunch(url)) {
      await launch(url);
    }
    else showDialog(context: context, builder: (context) =>
      AlertDialog(
        title: Text('Could not launch url'),
        content: Text('Make sure you have internet connection. And a browser.'),
      )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: ()  => Navigator.of(context).pop(),
        ),
        title: Text('Options'),
      ),
      body: ListView(
        children: <Widget>[
          _header('General'),
          CheckboxListTile(
            activeColor: Color(0xff1c004a),
            title: Text('Dark Mode'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) => value == true ? 
              DynamicTheme.of(context).setBrightness(Brightness.dark) :
              DynamicTheme.of(context).setBrightness(Brightness.light),
          ),
          ListTile(
            title: Text('Help'),
            leading: Icon(Icons.help),
            onTap: () => showDialog(context: context, builder: (context) =>
              AlertDialog(
                title: Text('Help'),
                content: Text('> Swipe from right to left on any item to remove it;\n>Press enter/search button on your keyboard when searching to send a request to the dictionary;\n>Undo your last deletion from the menu.\n\nIf you encounter any problems, please mail me at dragusinnathaniel@gmail.com and I\'ll answer ASAP'),
              )
            ),
          ),
          Divider(height: 1),
          _header('Sorting'),
          PopupMenuButton(
            child: ListTile(
              title: Text('Sort after adding word'),
              trailing: Text(_getSortingType()),
            ),
            onSelected: (int i) => setState(() => Data.sortingType = i),
            itemBuilder: (context) => <PopupMenuItem<int>>[
              PopupMenuItem<int>(
                child: Text('None'),
                value: 0,
              ),
              PopupMenuItem<int>(
                child: Text('Alphabetically'),
                value: 1,
              ),
              PopupMenuItem<int>(
                child: Text('by Size'),
                value: 2,
              ),
              PopupMenuItem<int>(
                child: Text('by Time Added'),
                value: 3,
              )
            ],
          ),
          Divider(height: 1),
          _header('Saving'),
          CheckboxListTile(
            activeColor: Color(0xff1c004a),
            title: Text('Save after adding word'),
            value: Data.saveAfterAdding,
            onChanged: ((value) => setState(() => Data.saveAfterAdding = value)),
          ),
          CheckboxListTile(
            activeColor: Color(0xff1c004a),
            title: Text('Save after removing word'),
            value: Data.saveAfterDeleting,
            onChanged: ((value) => setState(() => Data.saveAfterDeleting = value)),
          ),
          _header('Feedback'),
          ListTile(
            title: Text('Rate my app'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () =>  _launchUrl('https://play.google.com/store/apps/details?id=com.nathanielxd.lightweightvocabularyplus'),
          ),
          _header('About'),
          AboutListTile(
            applicationName: 'Lightweight Vocabulary Plus',
            applicationVersion: '0.9.0',
            aboutBoxChildren: <Widget>[
              Text('This app was made with the intent of easy access to a quick vocabulary and dictionary. No more waiting for webpages to load. I wanted it simple as I didn\'t want to overcomplicate it.\n\nIf you have any bugs, please e-mail me at dragusinnathaniel@gmail.com. Also thanks for buying my app! Cheers!'),
            ],
          )
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: TextStyle(
        color: Colors.blueGrey
      )),
    );
  }
}