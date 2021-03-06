import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget{

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords>{

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _bigFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemBuilder: (BuildContext _context, int i){
      // Add a one-pixel-high divider widget before each row
      // in the ListView.
      if (i.isOdd) {
        return Divider();
      }

      // The syntax "i ~/ 2" divides i by 2 and returns an
      // integer result.
      // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
      // This calculates the actual number of word pairings
      // in the ListView,minus the divider widgets.
      final int index = i ~/ 2;
      // If you've reached the end of the available word
      // pairings...
      if (index >= _suggestions.length) {
        // ...then generate 10 more and add them to the
        // suggestions list.
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    },
  );

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _bigFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else{
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (                     // Add from here...
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context){
            final tiles = _saved.map((pair) => ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _bigFont,
                ),
            ));
            final divided = tiles.isNotEmpty
                ? ListTile.divideTiles(context: context, tiles: tiles).toList()
                : <Widget>[];
            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          }
      )
    );
  }
}