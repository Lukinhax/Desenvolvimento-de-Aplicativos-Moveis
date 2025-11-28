import 'dart:convert';

class Livro {
  String titulo;
  String autor;
  int anoPublicacao;
  String genero;
  int avaliacao;
  String descricao;
  String? imagemCapa;

  Livro({
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
    required this.genero,
    required this.avaliacao,
    required this.descricao,
    this.imagemCapa,
  });

  // --- 1. Para a API do Google Books ---
  factory Livro.fromGoogleJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'];
    
    // Tratamento de imagem para HTTPS
    String? img = info['imageLinks']?['thumbnail'];
    if (img != null && img.startsWith('http://')) {
      img = img.replaceFirst('http://', 'https://');
    }

    // Tratamento seguro da Data
    String dataString = (info['publishedDate'] ?? '').toString();
    int ano = 0;
    if (dataString.length >= 4) {
      ano = int.tryParse(dataString.substring(0, 4)) ?? 0;
    }

    return Livro(
      titulo: info['title'] ?? 'Sem título',
      autor: (info['authors'] as List?)?.join(", ") ?? 'Desconhecido',
      anoPublicacao: ano,
      genero: (info['categories'] as List?)?.first ?? 'Geral',
      avaliacao: (info['averageRating'] as num?)?.toInt() ?? 0,
      descricao: info['description'] ?? 'Sem descrição.',
      imagemCapa: img,
    );
  }

  // --- 2. Para o PrefsService (Banco Local) ---
  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      anoPublicacao: map['anoPublicacao']?.toInt() ?? 0,
      genero: map['genero'] ?? '',
      avaliacao: map['avaliacao']?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      imagemCapa: map['imagemCapa'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'anoPublicacao': anoPublicacao,
      'genero': genero,
      'avaliacao': avaliacao,
      'descricao': descricao,
      'imagemCapa': imagemCapa,
    };
  }

  String toJson() => json.encode(toMap());
  factory Livro.fromJson(String source) => Livro.fromMap(json.decode(source));
}