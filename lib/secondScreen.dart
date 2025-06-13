import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book.dart';

class SecondScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Books Search',
      home: SecondScreen(),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>{
  final TextEditingController _controller = TextEditingController();
  List<Book> _books = [];
  bool _loading = false;

  Future<void> _searchBooks(String query) async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}');
    final response = await http.get(url);

    if (response.statusCode == 200){
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];

      setState((){
        _books = items.map((item) {
         final volumeInfo = item['volumeInfo'];
        return Book(
        title: volumeInfo['title'] ?? 'No Title',
        authors: (volumeInfo['authors'] ?? ['Unknown']).join(','),
        thumbnail: volumeInfo['imageLinks']?['thumbnail'] ?? '',
        );
      }).toList();
      _loading = false;
    });
  } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load books');
  }
}

@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(title: Text('Google Books Search')),
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children:[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search Books...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(onPressed: ()=> _searchBooks(_controller.text),
              child: Text('Search'),
            ),
          ],
        ),
        SizedBox(height:16),
        if (_loading)
          Center(child: CircularProgressIndicator())
        else 
          Expanded(
            child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index){
                  final book = _books[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300, width: 1), // ← 下線
                      ),
                    ),
                    child: ListTile(
                      leading: book.thumbnail.isNotEmpty
                          ? Image.network(book.thumbnail)
                          : Icon(Icons.book),
                      title: Text(book.title),
                      subtitle: Text(book.authors),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}