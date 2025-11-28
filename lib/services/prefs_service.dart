import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/livro.dart';

class PrefsService {
  static const String _keyLivros = 'lista_livros';
  static const String _keyUser = 'usuario_cadastrado';

  // === AUTENTICAÇÃO ===
  static Future<bool> cadastrarUsuario(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> user = {'email': email, 'senha': senha};
    return await prefs.setString(_keyUser, jsonEncode(user));
  }

  static Future<bool> login(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(_keyUser);
    
    if (userString == null) return false;

    Map<String, dynamic> user = jsonDecode(userString);
    return (user['email'] == email && user['senha'] == senha);
  }

  static Future<void> logout() async {
    // Implementar lógica de logout se necessário
  }

  // === LIVROS (CRUD Local) ===
  static Future<void> _persistirLivros(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    final listaMap = livros.map((e) => e.toMap()).toList();
    await prefs.setString(_keyLivros, jsonEncode(listaMap));
  }

  static Future<void> salvarLivro(Livro livro) async {
    final livros = await buscarLivros();
    livros.add(livro);
    await _persistirLivros(livros);
  }

  static Future<List<Livro>> buscarLivros() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_keyLivros);

    if (jsonString == null) return [];

    List<dynamic> listaDecodificada = jsonDecode(jsonString);
    return listaDecodificada.map((e) => Livro.fromMap(e)).toList();
  }

  static Future<void> atualizarLivro(int indice, Livro livroAtualizado) async {
    final livros = await buscarLivros();
    if (indice < 0 || indice >= livros.length) return;
    livros[indice] = livroAtualizado;
    await _persistirLivros(livros);
  }

  static Future<void> removerLivro(int indice) async {
    final livros = await buscarLivros();
    if (indice < 0 || indice >= livros.length) return;
    livros.removeAt(indice);
    await _persistirLivros(livros);
  }
}