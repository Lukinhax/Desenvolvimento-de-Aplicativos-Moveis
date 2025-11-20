class Livro {
  String titulo;
  String autor;
  int anoPublicacao;
  String genero;
  int avaliacao; // de 1 a 5
  String descricao;

  // Construtor
  Livro({
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
    required this.genero,
    required this.avaliacao,
    required this.descricao,
  });
}