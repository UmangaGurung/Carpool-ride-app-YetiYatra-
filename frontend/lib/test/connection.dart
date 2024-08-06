import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String url = 'http://192.168.1.66:4000';

  Future<String> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$url/data'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        throw Exception('Failed to load data: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  Future<String> sendData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$url/data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to send data: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      throw Exception('Error sending data: $error');
    }
  }

}