import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/livro.dart';

class ApiService {
  // Busca livros na API do Google
  static Future<List<Livro>> buscarLivrosOnline(String query) async {
    // query = termo de pesquisa (ex: 'harry potter', 'flutter')
    if (query.isEmpty) query = 'livros mais vendidos';

    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=20');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['totalItems'] == 0 || data['items'] == null) {
        return [];
      }

      final List items = data['items'];
      return items.map((json) => Livro.fromGoogleJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar livros na API');
    }
  }
}