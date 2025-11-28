import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../services/api_service.dart';
import '../services/prefs_service.dart';
import '../widgets/card_livro.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  int _indiceAba = 0; // 0 = Local, 1 = API
  
  // Variáveis da Lista Local
  List<Livro> _meusLivros = [];
  bool _carregandoLocal = true;

  // Variáveis da API
  late Future<List<Livro>> _apiFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarLivrosLocais();
    _apiFuture = ApiService.buscarLivrosOnline("programacao");
  }

  // --- Lógica Local (CRUD) ---
  Future<void> _carregarLivrosLocais() async {
    setState(() => _carregandoLocal = true);
    final livros = await PrefsService.buscarLivros();
    if (!mounted) return;
    setState(() {
      _meusLivros = livros;
      _carregandoLocal = false;
    });
  }

  Future<void> _removerLocal(int index) async {
    await PrefsService.removerLivro(index);
    _carregarLivrosLocais();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Livro removido.")));
  }

  Future<void> _navegarCadastro({Livro? livro, int? indice}) async {
    final args = (livro != null && indice != null) ? {'livro': livro, 'indice': indice} : null;
    await Navigator.pushNamed(context, 'modificacoes', arguments: args);
    _carregarLivrosLocais(); // Recarrega ao voltar
  }

  // --- Lógica da API ---
  void _pesquisarApi() {
    setState(() {
      _apiFuture = ApiService.buscarLivrosOnline(_searchController.text);
    });
  }

  Future<void> _salvarDaApi(Livro livro) async {
    await PrefsService.salvarLivro(livro);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Livro salvo na biblioteca!")));
    _carregarLivrosLocais(); // Atualiza a lista local em background
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),
      
      // Barra Inferior para navegar entre Abas
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAba,
        onTap: (idx) => setState(() => _indiceAba = idx),
        selectedItemColor: const Color(0xFF7086EC),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: "Minha Biblioteca"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar Online"),
        ],
      ),

      // Botão Flutuante (Só aparece na aba Local para Criar novo)
      floatingActionButton: _indiceAba == 0 
        ? FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF7086EC),
            onPressed: () => _navegarCadastro(),
            child: const Icon(Icons.add),
          )
        : null,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _indiceAba == 0 ? _buildListaLocal() : _buildListaApi(),
        ),
      ),
    );
  }

  // === WIDGET DA ABA 1: LOCAL ===
  Widget _buildListaLocal() {
    if (_carregandoLocal) return const Center(child: CircularProgressIndicator(color: Colors.white));
    
    if (_meusLivros.isEmpty) {
      return const Center(
        child: Text("Sua biblioteca está vazia.\nAdicione livros manualmente ou da API!", 
          textAlign: TextAlign.center, 
          style: TextStyle(color: Colors.white, fontSize: 16)
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Meus Livros Salvos", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _meusLivros.length,
            itemBuilder: (context, index) {
              final livro = _meusLivros[index];
              return CardLivro(
                livro: livro,
                onTap: () => Navigator.pushNamed(context, 'detalhes', arguments: livro),
                onEditar: () => _navegarCadastro(livro: livro, indice: index),
                onExcluir: () => _removerLocal(index),
              );
            },
          ),
        ),
      ],
    );
  }

  // === WIDGET DA ABA 2: API ===
  Widget _buildListaApi() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Pesquisar no Google Books",
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _pesquisarApi),
            ),
            onSubmitted: (_) => _pesquisarApi(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<Livro>>(
            future: _apiFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (snapshot.hasError) return const Center(child: Text("Erro na busca", style: TextStyle(color: Colors.white)));
              if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Nada encontrado", style: TextStyle(color: Colors.white)));

              final livros = snapshot.data!;
              return ListView.builder(
                itemCount: livros.length,
                itemBuilder: (context, index) {
                  return CardLivro(
                    livro: livros[index],
                    // Ação de Salvar (Copia da API para o Local)
                    onSalvar: () => _salvarDaApi(livros[index]),
                    onTap: () => Navigator.pushNamed(context, 'detalhes', arguments: livros[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}