import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> solveForHanoi(
  int disks,
  List<String> pegs,
  String from,
  String to,
) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final body = jsonEncode({
    "size": disks,
    "k": pegs.length,
    "pegs": pegs,
    "from": from,
    "to": to,
  });

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Error: ${response.statusCode}');
  }
  return null;
}
