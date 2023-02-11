import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/configure/color.dart';
import 'package:todo/list_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          popupMenuTheme: PopupMenuThemeData(color: color.cb),
          iconTheme: IconThemeData(color: color.cb),
          appBarTheme:
              AppBarTheme(color: color.cw, centerTitle: true, elevation: 0)),
      title: "ToDo App",
      home: ListData(),
    );
  }
}
