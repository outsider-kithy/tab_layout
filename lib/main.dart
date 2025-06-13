import 'package:flutter/material.dart';
import 'database.dart';
import 'firstScreen.dart';
import 'thirdScreen.dart';
import 'secondScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Tab Layout Demo',
      home: MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FirstScreenApp(),
    SecondScreenApp(),
    ThirdScreenApp(),
  ];

  void _onTabTapped(int index){
    setState(() {
      _currentIndex  = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'ホーム'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '検索'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'マイページ'
            ),
          ]),
    );
  }
}