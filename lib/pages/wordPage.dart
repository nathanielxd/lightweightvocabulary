import 'package:flutter/material.dart';
import 'package:lightweightvocabularypro/dictionary.dart';
import 'package:lightweightvocabularypro/data.dart';

class WordPage extends StatelessWidget {

  final Word word;
  final bool wasSearched;

  final Function(Word) addWordCallback;

  WordPage({@required this.word, @required this.wasSearched, @required this.addWordCallback, Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 40),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(word.word, style: TextStyle(
                          fontFamily: 'Raleway-Medium',
                          fontSize: 24,
                        )),
                        word.phonetic != null ? Text(word.phonetic, style: TextStyle(
                          color: Colors.grey[700]
                        )) : Container(),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Divider(color: Colors.grey[400], height: 0),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _wordDefinitionBuilder(context, word.meaning),
              )
            ),
            wasSearched ? MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              elevation: 0,
              color: Colors.grey[300],
              child: Text('Add in vocabulary'),
              onPressed: () {
                addWordCallback(word);
                Navigator.of(context).pop();
              }
            ) : Container()
          ],
        ),
      ),
    );
  }

  Widget _wordDefinitionBuilder(BuildContext context, WordMeaning wordMeaning) {

    List<Widget> widgets = List();

    int counter = 1;

    void _addData(WordData data, int counter) {

      String synonyms = '';
      if(data.synonyms != null) {
        synonyms = 'synonyms: ';
        data.synonyms.forEach((synonym) => synonyms += '$synonym, ');
        synonyms = synonyms.substring(0, synonyms.length - 2);
      }

      widgets.addAll(
        <Widget>[
          data.definition != null ? Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(counter.toString() + '. ' + data.definition, style: Theme.of(context).textTheme.body1),
          ) : Container(),
          data.example != null ? Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('"' + data.example + '"', style: Theme.of(context).textTheme.caption),
          ) : Container(),
          synonyms != '' ? Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(synonyms, style: Theme.of(context).textTheme.body2)
          ) : Container(),
          Divider()
        ]
      );
    }

    if(wordMeaning.noun != null) {
      widgets.add(Padding(
        padding: CustomTheme.meaningPadding,
        child: Text('noun', style: Theme.of(context).textTheme.headline),
      ));
      wordMeaning.noun.forEach((noun) {
        _addData(noun, counter);
        counter++;
      });
    }
    counter = 1;

    if(wordMeaning.adjective != null) {
      widgets.add(Padding(
        padding: CustomTheme.meaningPadding,
        child: Text('adjective', style: Theme.of(context).textTheme.headline),
      ));
      wordMeaning.adjective.forEach((adjective) {
        _addData(adjective, counter);
        counter++;
      });
    }
    counter = 1;

    if(wordMeaning.verb != null) {
      widgets.add(Padding(
        padding: CustomTheme.meaningPadding,
        child: Text('verb', style: Theme.of(context).textTheme.headline),
      ));
      wordMeaning.verb.forEach((verb) {
        _addData(verb, counter);
        counter++;
      });
    }
    counter = 1;

    if(wordMeaning.exclamation != null) {
      widgets.add(Padding(
        padding: CustomTheme.meaningPadding,
        child: Text('exclamation', style: Theme.of(context).textTheme.headline),
      ));
      wordMeaning.exclamation.forEach((exclamation) {
        _addData(exclamation, counter);
        counter++;
      });
    }
    counter = 1;

    if(wordMeaning.abbreviation != null) {
      widgets.add(Padding(
        padding: CustomTheme.meaningPadding,
        child: Text('abbreviation', style: Theme.of(context).textTheme.headline),
      ));
      wordMeaning.abbreviation.forEach((abbreviation) {
        _addData(abbreviation, counter);
        counter++;
      });
    }

    if(word.origin != null) {
      widgets.add(Padding(
        padding: CustomTheme.meaningPadding,
        child: Text('origin', style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Color(0xFF290014)
        )),
      ));
      widgets.add(Text(word.origin, style: TextStyle(
        fontSize: 12,
      )));
    }

    return ListView(
      children: widgets
    );
  }
}