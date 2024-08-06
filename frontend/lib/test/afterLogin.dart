import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeti_yatra_project/welcome.dart';
import 'package:yeti_yatra_project/welcome.dart';

class TokenData extends StatefulWidget {
  final token;
  const TokenData({@required this.token, Key? key}) : super(key: key);

  @override
  State<TokenData> createState() => _TokenDataState();
}

class _TokenDataState extends State<TokenData> {
  late String username;

  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['username'];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '$username',
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      await removeToken();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardWidget(),
                        ),
                      );
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}

Future<void> removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}
