import 'package:flutter/material.dart';
import 'package:yeti_yatra_project/SearchScreen/search_result.dart';

void main(){
  runApp(TestRun());
}

class TestRun extends StatelessWidget {
  const TestRun({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SearchResult(),
    );
  }
}
