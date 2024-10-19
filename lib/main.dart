import 'package:flutter/material.dart';
import 'package:tezos/Screens/MainScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Mainscreen(),
    );
  }
}
