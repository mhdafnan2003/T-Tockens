<<<<<<< HEAD
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
=======
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
      debugShowCheckedModeBanner: true,
      home: Mainscreen(),
    );
  }
}
>>>>>>> 7b5ebc826356e6fd6e1bed546c5c63959e89a441
