import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lightweightvocabularypro/dictionary.dart';
import 'package:lightweightvocabularypro/widgets/customAppbar.dart';
import 'package:lightweightvocabularypro/widgets/wordWidget.dart';
import 'package:lightweightvocabularypro/data.dart';
import 'wordPage.dart';
import 'optionsPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future dataLoader;

  Future savedDataLoader = Future.delayed(Duration(milliseconds: 100));

  List<Word> showingWords = Data.words;

  @override
  void initState() {
    super.initState();

    dataLoader = load();

    loadSettings();
  }

  void loadSettings() async {
    await SharedPreferences.getInstance().then((prefs) {
      Data.sortingType = prefs.getInt('sortingType') ?? 0;
      Data.saveAfterAdding = prefs.getBool('saveAfterAdding') ?? true;
      Data.saveAfterDeleting = prefs.getBool('saveAfterDeleting') ?? true;
      Data.isPaid = prefs.getBool('isPaid') ?? false;
    });
  }

  void save() async {
    savedDataLoader = null;

    Directory dir = await getApplicationDocumentsDirectory();
    var dirPath = dir.path;
    var file = File('$dirPath/words.json');

    List<String> wordsJson = List();
    Data.words.forEach((word) {
      wordsJson.add(jsonEncode(word.toJson()));
    });

    setState(() {
      savedDataLoader = file.writeAsString(wordsJson.toString());
      savedDataLoader = Future.delayed(Duration(milliseconds: 600));
    });
  }

  Future load() async {
    await getApplicationDocumentsDirectory().then((directory) async {
      var dirPath = directory.path;
      var file = File('$dirPath/words.json');

      await file.readAsString().then((value) {
        List list = jsonDecode(value);
        list.forEach((i) => Data.words.add(Word.fromJson(i)));
      });
    });
  }

  void addWord(Word word) {
    setState(() {
      word.timeAdded = DateTime.now();
      Data.words.add(word);
      Data.sortWords();
      startSearching(word.word);
    });
    if(Data.saveAfterAdding) save();
  }

  void removeWord(Word word) {
    setState(() {
      Data.words.remove(word);
    });
    if(Data.saveAfterDeleting) save();
  }

  void startSearching(String searchParam) => setState(() => showingWords = Data.words.where((i) => i.word.contains(searchParam)).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: CustomAppBar(
        appBar: AppBar(), 
        searchCallback: startSearching,
        addWordCallback: addWord
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              FutureBuilder(
                future: savedDataLoader,
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.done:
                      return Icon(Icons.check, size: 20);
                      break;
                    default:
                      return Container(width: 20, height: 20, child: 
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1c004a))));
                      break;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text('plus vocabulary', style: TextStyle(
                  fontFamily: 'Raleway-Light'
                )),
              ),
              Spacer(),
              PopupMenuButton(
                icon: Icon(Icons.sort),
                onSelected: ((int i) {
                  switch(i) {
                    case 1:
                      Data.words.sort((a, b) => a.word.compareTo(b.word));
                      setState(() => showingWords = Data.words);
                      save();
                      break;
                    case 2:
                      Data.words.sort((a, b) => a.word.length.compareTo(b.word.length));
                      setState(() => showingWords = Data.words);
                      save();
                      break;
                    case 3:
                      Data.words.sort((a, b) => a.timeAdded.compareTo(b.timeAdded));
                      setState(() => showingWords = Data.words);
                      save();
                      break;
                  }
                }),
                itemBuilder: (context) => <PopupMenuItem<int>>[
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.sort_by_alpha),
                        title: Text('Sort Alphabetically'),
                      ),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.line_weight),
                        title: Text('Sort by Size'),
                      ),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.timelapse),
                        title: Text('Sort by Time Added'),
                      ),
                    ),
                    value: 3,
                  )
                ],
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: ((int i) {
                  switch(i) {
                    case 0:
                      save();
                      break;
                    case 1:
                      addWord(Data.deleted);
                      break;
                    case 2:
                      if(Theme.of(context).brightness == Brightness.light)
                        DynamicTheme.of(context).setBrightness(Brightness.dark);
                      else
                        DynamicTheme.of(context).setBrightness(Brightness.light);
                      break;
                    case 3:
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OptionsPage()));
                      break;
                    case 4:
                      showDialog(context: context, builder: (context) => 
                      AlertDialog(
                        title: Text('Clear your vocabulary?'),
                        content: Text('You will clear all words in your vocabulary. Are you sure?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              setState(() => Data.words.clear());
                              save();
                              Navigator.of(context).pop();
                            },
                            child: Text('Sure'),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('No'),
                          )
                        ],
                      ));
                  }
                }),
                itemBuilder: (context) => <PopupMenuItem<int>>[
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.save),
                        title: Text('Save'),
                      ),
                    ),
                    value: 0,
                  ),
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.delete_sweep),
                        title: Text('Restore Deleted'),
                      ),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.clear_all),
                        title: Text('Clear All'),
                      ),
                    ),
                    value: 4,
                  ),
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.mood),
                        title: Text('Dark Mode'),
                        trailing: Theme.of(context).brightness == Brightness.light ?
                          Text('Light', style: Theme.of(context).textTheme.body2) :
                          Text('Dark', style: Theme.of(context).textTheme.body2)
                      ),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem<int>(
                    child: Container(
                      width: 240,
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Options'),
                      ),
                    ),
                    value: 3,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: dataLoader,
          builder: (context, snapshot) => 
          ListView.builder(
            itemCount: showingWords.length,
            itemBuilder: (context, index) =>
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => 
                WordPage(
                  word: showingWords[index],
                  wasSearched: false,
                  addWordCallback: addWord,
                )
              ),
              child: WordWidget(
                word: showingWords[index],
                removeWordCallback: removeWord,
                searchCallback: startSearching,
              ),
            )
          )
        )
      )
    );
  }
}