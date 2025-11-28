import 'package:flutter/material.dart';
import '../models/livro.dart';

class CardLivro extends StatelessWidget {
  final Livro livro;
  final VoidCallback? onTap;
  final VoidCallback? onEditar;
  final VoidCallback? onExcluir;
  final VoidCallback? onSalvar; // Para a lista da API

  const CardLivro({
    super.key,
    required this.livro,
    this.onTap,
    this.onEditar,
    this.onExcluir,
    this.onSalvar,
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
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            // Imagem (Capa) ou Ícone
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(8),
                image: livro.imagemCapa != null 
                  ? DecorationImage(
                      image: NetworkImage(livro.imagemCapa!),
                      fit: BoxFit.cover,
                    )
                  : null,
              ),
              child: livro.imagemCapa == null 
                  ? const Icon(Icons.menu_book, color: Color(0xFF3540A5)) 
                  : null,
            ),
            const SizedBox(width: 16),
            // Dados do Livro
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livro.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    livro.autor,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  if (livro.avaliacao > 0)
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < livro.avaliacao ? Icons.star : Icons.star_border,
                          color: Colors.amber.shade600,
                          size: 16,
                        ),
                      ),
                    )
                  else
                    const Text("Sem avaliação", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            // Botões de Ação
            Column(
              children: [
                if (onSalvar != null)
                  IconButton(
                    icon: const Icon(Icons.bookmark_add, color: Colors.green),
                    tooltip: 'Salvar na Biblioteca',
                    onPressed: onSalvar,
                  ),
                if (onEditar != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF7086EC)),
                    onPressed: onEditar,
                  ),
                if (onExcluir != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
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