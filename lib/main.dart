// ignore_for_file: unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, unused_import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/model/counter.dart';
import 'package:tracker/interface/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PageIndexProviderModel(),
        child: MaterialApp(home: PageViewDemo()));
  }
}
