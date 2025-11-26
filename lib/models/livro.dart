import 'dart:convert';

class Livro {
  String titulo;
  String autor;
  int anoPublicacao;
  String genero;
  int avaliacao;
  String descricao;

  Livro({
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
    required this.genero,
    required this.avaliacao,
    required this.descricao,
  });

  // Converte para Map (para salvar)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'anoPublicacao': anoPublicacao,
      'genero': genero,
      'avaliacao': avaliacao,
      'descricao': descricao,
    };
  }

  // Cria a partir de Map (para ler)
  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      anoPublicacao: map['anoPublicacao']?.toInt() ?? 0,
      genero: map['genero'] ?? '',
      avaliacao: map['avaliacao']?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
    );
  }

  // Métodos auxiliares para JSON (Checklist: Persistência)
  String toJson() => json.encode(toMap());

  factory Livro.fromJson(String source) => Livro.fromMap(json.decode(source));
}