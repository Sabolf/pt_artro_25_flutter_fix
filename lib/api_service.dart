import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>?> fetchData() async {
    final url = Uri.parse('https://voteptartro.wisehub.pl/api/?action=get-program-flat');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>; // SAFER
        print('✅ API Response:\n$data');
        return data;
      } else {
        print('❌ Error: ${response.statusCode}');
        return null;
      }

    } catch (e) {
      print('🚨 Exception caught: $e');
      return null;
    }
  }
}
