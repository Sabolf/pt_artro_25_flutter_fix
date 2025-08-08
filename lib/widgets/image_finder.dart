import 'package:flutter/services.dart';
import 'dart:convert';

Future<String?> findImagePathById(String id) async {
  final String jsonString = await rootBundle.loadString('assets/image_paths.json');
  final Map<String, dynamic> data = jsonDecode(jsonString);
  final List<dynamic> imagePaths = data['images'];

  for (final path in imagePaths) {
    if (path is String && path.contains(id)) {
      print("FOUND $id in $path");
      return path;
    }
  }
  return null;
}
