import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> stepsForSolveHanoi(Map<String, dynamic> body) async {
  final url = Uri.parse(
    'https://cocoa-truffle-mix-lhptr.ondigitalocean.app/api/hanoi',
  );

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Error: ${response.statusCode}');
  }
  return null;
}
