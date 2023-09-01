import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/db_provider.dart';
import 'package:todo/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (context) => DatabaseProvider(),),
     ],
      child: MaterialApp(
        title: 'TODO APP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}


