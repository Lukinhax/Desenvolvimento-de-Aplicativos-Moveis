import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../services/prefs_service.dart';
import '../widgets/card_livro.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  List<Livro> _livros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    setState(() => _carregando = true);
    final livros = await PrefsService.buscarLivros();
    if (!mounted) return;
    setState(() {
      _livros = livros;
      _carregando = false;
    });
  }

  Future<void> _navegarParaCadastro({Livro? livro, int? indice}) async {
    final args = (livro != null && indice != null)
        ? {
            'livro': livro,
            'indice': indice,
          }
        : null;
    await Navigator.pushNamed(
      context,
      'modificacoes',
      arguments: args,
    );
    if (!mounted) return;
    await _carregarLivros();
  }

  void _abrirDetalhes(Livro livro) {
    Navigator.pushNamed(context, 'detalhes', arguments: livro);
  }

  Future<void> _removerLivro(int indice) async {
    await PrefsService.removerLivro(indice);
    await _carregarLivros();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro removido com sucesso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              _cabecalho(),
              const SizedBox(height: 32),
              Expanded(
                child: _carregando
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : RefreshIndicator(
                        color: const Color(0xFF7086EC),
                        onRefresh: _carregarLivros,
                        child: _livros.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 120),
                                  Center(
                                    child: Text(
                                      'Nenhum livro cadastrado ainda.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: _livros.length,
                                itemBuilder: (context, index) {
                                  final livro = _livros[index];
                                  return CardLivro(
                                    livro: livro,
                                    onTap: () => _abrirDetalhes(livro),
                                    onEditar: () => _navegarParaCadastro(
                                      livro: livro,
                                      indice: index,
                                    ),
                                    onExcluir: () => _removerLivro(index),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF7086EC),
        icon: const Icon(Icons.add),
        label: const Text('Novo livro'),
        onPressed: () => _navegarParaCadastro(),
      ),
    );
  }

  Widget _cabecalho() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Minha Biblioteca",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7086EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onPressed: () => _navegarParaCadastro(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Adicionar livro",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
