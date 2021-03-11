import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var corPrincipal = Colors.blue;
    var titulo = 'Conversor de Moedas - EAI';

    return MaterialApp(
      title: titulo,
      //themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(primaryColor: corPrincipal), //DARK THEME
      theme: ThemeData(
        primarySwatch: corPrincipal,
      ),
      home: MyHomePage(title: titulo),
      debugShowCheckedModeBanner: false,
    );
  }
}
