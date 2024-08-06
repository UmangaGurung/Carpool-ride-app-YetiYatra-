import 'package:flutter/material.dart';
import 'connection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node.js Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  String _message = 'No data yet';
  String _errorMessage = '';

  void _getData() async {
    try {
      final data = await apiService.fetchData();
      setState(() {
        _message = data;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _postData() async {
    try {
      final response = await apiService.sendData({'key': 'value'});
      setState(() {
        _message = response;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Node.js Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            Text(_message),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getData,
              child: Text('Get Data'),
            ),
            ElevatedButton(
              onPressed: _postData,
              child: Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}