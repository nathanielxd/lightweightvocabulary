import 'package:flutter/material.dart';
import 'package:lightweightvocabularypro/dictionary.dart';
import 'package:lightweightvocabularypro/data.dart';

class WordWidget extends StatefulWidget {

  final Word word;

  final void Function(Word) removeWordCallback;
  final void Function(String word) searchCallback;

  WordWidget({@required this.word, @required this.removeWordCallback, @required this.searchCallback, Key key}) : super(key: key);

  @override
  _WordWidgetState createState() => _WordWidgetState();
}

class _WordWidgetState extends State<WordWidget> {

  void dismissWidget() {
    Data.deleted = widget.word;
    setState(() => widget.removeWordCallback(widget.word));
    widget.searchCallback(Data.appBarSearchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(UniqueKey().toString()),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red[800],
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.delete_outline, size: 28),
        ),
      ),
      onDismissed: (direction) => dismissWidget(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.word.word, style: Theme.of(context).textTheme.body1),
            _wordDefBuilder()
          ],
        ),
      ),
    );
  }

  Widget _wordDefBuilder() {

    String def;

    if(widget.word.meaning.exclamation != null) def = widget.word.meaning.exclamation[0].definition;
    if(widget.word.meaning.verb != null) def = widget.word.meaning.verb[0].definition;
    if(widget.word.meaning.adjective != null) def = widget.word.meaning.adjective[0].definition;
    if(widget.word.meaning.noun != null) def = widget.word.meaning.noun[0].definition;
    if(widget.word.meaning.abbreviation != null) def = widget.word.meaning.abbreviation[0].definition;

    return Text(def, style: Theme.of(context).textTheme.body2);
  }
}