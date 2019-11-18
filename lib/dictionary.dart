import 'dart:io';
import 'dart:convert';

class Dictionary {

  static Future<Word> request(String word) async {

    word = word.replaceAll(' ', '_');
    
    var request = await HttpClient().getUrl(
      Uri.parse('https://googledictionaryapi.eu-gb.mybluemix.net/?define=$word&lang=en'
    ));

    var response = await request.close();

    String contents = '';
    await for(var content in response.transform(Utf8Decoder())) {
      contents += content;
    }

    Word result;

    try { 
      result = Word.fromJson(jsonDecode(contents)[0]); 
    } 
    catch(ex) { 
      return Word(word: 'ERROR~NOWORD');
    }
    
    return result;
  }
}

class Word {
  
  Word({this.word});

  String word;
  String phonetic;
  String origin;
  WordMeaning meaning;

  DateTime timeAdded;
  String timeAddedString;

  Word.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    phonetic = json['phonetic'];
    origin = json['origin'];
    timeAddedString = json['time_added'];
    meaning = WordMeaning.fromJson(json['meaning']);

    if(timeAddedString != null)
      timeAdded = DateTime.parse(timeAddedString);
  }

  Map<String, dynamic> toJson() {
    timeAddedString = timeAdded.toString();

    return {
    "word": word,
    "phonetic": phonetic,
    "origin": origin,
    "time_added": timeAddedString,
    "meaning": meaning.toJson()
  };
  }
}

class WordMeaning {

  List<WordData> noun;
  List<WordData> adjective;
  List<WordData> exclamation;
  List<WordData> verb;
  List<WordData> abbreviation;

  WordMeaning.fromJson(Map<String, dynamic> json) {
    if(json['noun'] != null) noun = (json['noun'] as List).map((i) => WordData.fromJson(i)).toList();
    if(json['adjective'] != null) adjective = (json['adjective'] as List).map((i) => WordData.fromJson(i)).toList();
    if(json['exclamation'] != null) exclamation = (json['exclamation'] as List).map((i) => WordData.fromJson(i)).toList();
    if(json['verb'] != null) verb = (json['verb'] as List).map((i) => WordData.fromJson(i)).toList();
    if(json['abbreviation'] != null) abbreviation = (json['abbreviation'] as List).map((i) => WordData.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() => {
      if(noun != null) "noun": noun.map((i) => i.toJson()).toList(),
      if(adjective != null) "adjective": adjective.map((i) => i.toJson()).toList(),
      if(exclamation != null) "exclamation": exclamation.map((i) => i.toJson()).toList(),
      if(verb != null) "verb": verb.map((i) => i.toJson()).toList(),
      if(abbreviation != null) "abbreviation": abbreviation.map((i) => i.toJson()).toList()
    };
}

class WordData {

  String definition;
  String example;
  List<String> synonyms;

  WordData.fromJson(Map<String, dynamic> json) {
    definition = json['definition'];
    example = json['example'];
    if(json['synonyms'] != null) synonyms = (json['synonyms'] as List).map<String>((i) => i).toList();
  }

  Map<String, dynamic> toJson() => {
      "definition": definition,
      "example": example,
      "synonyms": synonyms
    };
}