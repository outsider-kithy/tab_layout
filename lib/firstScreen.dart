import 'package:flutter/material.dart';

class FirstScreenApp extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreenApp> {

  final List<String> items = List.generate(30, (index) => "Item ${index + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('ListView (iOS風)')),
    body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
         final item = items[index];

         return Dismissible(
             key: Key(item),
             direction:  DismissDirection.endToStart,
             background: Container(
               color: Colors.red,
               alignment: Alignment.centerRight,
               padding: EdgeInsets.symmetric(horizontal: 20),
               child: Icon(Icons.delete, color: Colors.white),
             ),
             onDismissed: (direction){
                 setState(() {
                   items.removeAt(index);
                 });
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('$item を削除しました')),
             );
          },
      child: ListTile(
        title: Text(item),
        trailing: Icon(Icons.chevron_right),
      ),
      );
      },
    ),
  );//return Center(child: Text('ホーム'));
  }
}