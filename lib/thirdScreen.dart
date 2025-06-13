import 'package:flutter/material.dart';

class ThirdScreenApp extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreenApp> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:  Text('3rd Screen')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text('3rd Screen'),
      ),
    );
}
}