import 'package:flutter/material.dart';
import 'package:lightweightvocabularypro/data.dart';
import 'package:lightweightvocabularypro/dictionary.dart';
import 'package:lightweightvocabularypro/pages/wordPage.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  final appBar;
  final void Function(String) searchCallback;
  final void Function(Word) addWordCallback;

  CustomAppBar({Key key, this.appBar, @required this.searchCallback, @required this.addWordCallback}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _CustomAppBarState extends State<CustomAppBar> {

  void initState() {
    super.initState();

    Data.appBarSearchController.addListener(searchClosure);
  }

  void dispose() {
    super.dispose();

    Data.appBarSearchController.dispose();
  }

  void searchClosure() {
    widget.searchCallback(Data.appBarSearchController.text);
  }

  void displayWord(String word) async {
    Future<Word> request = Dictionary.request(word);
    
    showDialog(context: context, builder: (context) =>
    FutureBuilder(
      future: request,
      builder: (context, AsyncSnapshot<Word> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.data.word == 'ERROR~NOWORD') {
            return AlertDialog(
              title: Text('Word cannot be found'),
              content: Text('Im sorry but your request could not be made.\nPlease try again if you\'re sure the word exists.\nMake sure you have connection to internet when searching for new word.'),
            );
          }
          else
            return WordPage(
              word: snapshot.data,
              wasSearched: true,
              addWordCallback: widget.addWordCallback
            );
        }
        else return Dialog(
          child: LinearProgressIndicator(),
        );
      })
    );
  }
  var formKey = GlobalKey<FormState>();

  var isSearching = false;
  
  Widget build(BuildContext context) {
    return AppBar(
      leading: !isSearching ?
        Padding(
          padding: EdgeInsets.all(12),
          child: Image(
            image: AssetImage('assets/icon.png'),
          ), 
        ) :
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() {
            isSearching = false;
            Data.appBarSearchController.clear();
            FocusScope.of(context).unfocus();
          }),
        ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Form(
        key: formKey,
        child: TextFormField(
          controller: Data.appBarSearchController,
          textInputAction: TextInputAction.search,
          validator: (value) {
            if(value.isEmpty || value == ' ') return 'Cannot be null';
            return null;
          },
          onEditingComplete: () {
            if(formKey.currentState.validate()) {
              displayWord(Data.appBarSearchController.text);
              FocusScope.of(context).unfocus();
            }
          },
          onTap: () => setState(() => isSearching = true),
          decoration: InputDecoration(
            hintText: 'Search',
            contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1c004a)),
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        ),
      ),
    );
  }
}