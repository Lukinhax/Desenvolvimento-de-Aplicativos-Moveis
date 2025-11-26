import 'package:flutter/material.dart';
import '../models/livro.dart';

class PaginaDetalhes extends StatelessWidget {
  const PaginaDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    final livro = ModalRoute.of(context)?.settings.arguments as Livro?;

    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detalhes do Livro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
            ],
          ),
          child: livro == null
              ? const Text('Nenhum livro selecionado.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.titulo,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Autor: ${livro.autor}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Ano: ${livro.anoPublicacao}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Gênero: ${livro.genero}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          "Avaliação: ",
                          style: TextStyle(fontSize: 18),
                        ),
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < livro.avaliacao ? Icons.star : Icons.star_border,
                            color: Colors.amber.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      livro.descricao,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}