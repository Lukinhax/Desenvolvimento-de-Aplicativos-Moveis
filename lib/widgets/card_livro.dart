import 'package:flutter/material.dart';
import '../models/livro.dart';

class CardLivro extends StatelessWidget {
  final Livro livro;
  final VoidCallback? onTap;
  final VoidCallback? onEditar;
  final VoidCallback? onExcluir;

  const CardLivro({
    super.key,
    required this.livro,
    this.onTap,
    this.onEditar,
    this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book, color: Color(0xFF3540A5)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livro.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${livro.autor} • ${livro.anoPublicacao}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < livro.avaliacao ? Icons.star : Icons.star_border,
                        color: Colors.amber.shade600,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF7086EC)),
                  tooltip: 'Editar',
                  onPressed: onEditar,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Excluir',
                  onPressed: onExcluir,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
