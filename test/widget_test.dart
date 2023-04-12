/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() async {
  await getApiOfDeezerMusic();
}

Future<void> getApiOfDeezerMusic() async {
  var url = Uri.parse('https://api.deezer.com/album/302127');
  final response = await http.get(url);
  final String jsonBody = response.body;
  final int statusCode = response.statusCode;

  if (statusCode != 200 || jsonBody == null) {
    print(response.reasonPhrase);
    throw new Exception("Lỗi load api");
  }

  debugPrint(jsonBody.toString());
}
*/
