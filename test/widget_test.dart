import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() async {
  String url =
      'https://cdns-preview-d.dzcdn.net/stream/c-deda7fa9316d9e9e880d2c6207e92260-10.mp3';
  int sizeInBytes = await getFileSize(url);
  log(formatSize(sizeInBytes));
}

Future<int> getFileSize(String text) async {
  var url = Uri.parse(text);
  http.Response response = await http.head(url);
  int? contentLength = int.tryParse(response.headers['content-length'] ?? '');
  return contentLength ?? 0;
}

String formatSize(int sizeInBytes) {
  double sizeInMB = sizeInBytes / (1024 * 1024);
  String size = sizeInMB.toStringAsFixed(1);
  return '$size MB';
}
