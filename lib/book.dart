import 'package:flutter/material.dart';

class Book {
  final String title;
  final String authors;
  final String thumbnail;

  Book({
    required this.title,
    required this.authors,
    required this.thumbnail
  });

  factory Book.fromMap(Map<String, dynamic> map){
    return Book(
        title: map['title'],
        authors: map['authors'],
        thumbnail: map['thumbnailUrl'],
    );
  }
}
