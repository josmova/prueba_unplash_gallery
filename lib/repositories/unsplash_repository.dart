import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';
import '../models/category.dart';
import 'package:logger/logger.dart';

class UnsplashRepository {
  final String apiKey = 'OYejWZho4XnWpQeD7mzAC8kjOon-5nVpZKm2mHnozNk';
  final String baseUrl = 'https://api.unsplash.com';
  var logger = Logger();

  Future<List<Photo>> getRandomPhotos(int count) async {
    final response = await http.get(
      Uri.parse('$baseUrl/photos/random?count=$count&client_id=$apiKey'),
    );

    logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List photosJson = json.decode(response.body);
      return photosJson.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener fotos aleatorias');
    }
  }

  Future<List<Photo>> searchPhotos(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/photos?query=$query&client_id=$apiKey'),
    );

    logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List photosJson = body['results'];
      return photosJson.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar fotos');
    }
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/topics?client_id=$apiKey'),
    );

    logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List categoriesJson = json.decode(response.body);
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener categorías');
    }
  }
}
