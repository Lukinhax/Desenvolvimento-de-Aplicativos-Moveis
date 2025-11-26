import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/livro.dart';
import '../services/prefs_service.dart';
import '../widgets/card_livro.dart';

class PaginaModificacoes extends StatefulWidget {
  const PaginaModificacoes({super.key});

  @override
  State<PaginaModificacoes> createState() => _PaginaModificacoesState();
}

class _PaginaModificacoesState extends State<PaginaModificacoes> {
  final _formKey = GlobalKey<FormState>();
  final _generoKey = GlobalKey<FormFieldState<String>>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _anoController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _descricaoController = TextEditingController();

  final List<String> _generos = const [
    "Selecione um gênero",
    "Ficção",
    "Romance",
    "Aventura",
    "Suspense",
    "Fantasia",
    "Biografia",
    "Histórico",
    "Terror",
  ];

  String _generoSelecionado = "Selecione um gênero";
  List<Livro> _livros = [];
  bool _carregandoLista = true;
  bool _salvando = false;
  int? _indiceEdicao;
  bool _argsProcessados = false;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsProcessados) return;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['livro'] is Livro) {
      _preencherFormulario(args['livro'] as Livro, indice: args['indice'] as int?);
    }
    _argsProcessados = true;
  }

  Future<void> _carregarLivros() async {
    final livros = await PrefsService.buscarLivros();
    if (!mounted) return;
    setState(() {
      _livros = livros;
      _carregandoLista = false;
    });
  }

  void _preencherFormulario(Livro livro, {int? indice}) {
    setState(() {
      _tituloController.text = livro.titulo;
      _autorController.text = livro.autor;
      _anoController.text = livro.anoPublicacao.toString();
      _generoSelecionado = livro.genero;
      _avaliacaoController.text = livro.avaliacao.toString();
      _descricaoController.text = livro.descricao;
      _indiceEdicao = indice;
    });
    _generoKey.currentState?.didChange(_generoSelecionado);
  }

  void _limparFormulario() {
    setState(() {
      _tituloController.clear();
      _autorController.clear();
      _anoController.clear();
      _avaliacaoController.clear();
      _descricaoController.clear();
      _generoSelecionado = _generos.first;
      _indiceEdicao = null;
    });
    _generoKey.currentState?.reset();
  }

  Future<void> _salvarLivro() async {
    if (!_formKey.currentState!.validate()) return;
    if (_generoSelecionado == _generos.first) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um gênero válido')),
      );
      return;
    }

    final avaliacao = int.tryParse(_avaliacaoController.text) ?? 0;
    if (avaliacao < 1 || avaliacao > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avaliação deve estar entre 1 e 5')),
      );
      return;
    }

    final livro = Livro(
      titulo: _tituloController.text.trim(),
      autor: _autorController.text.trim(),
      anoPublicacao: int.tryParse(_anoController.text) ?? DateTime.now().year,
      genero: _generoSelecionado,
      avaliacao: avaliacao,
      descricao: _descricaoController.text.trim(),
    );

    setState(() => _salvando = true);
    try {
      if (_indiceEdicao != null) {
        await PrefsService.atualizarLivro(_indiceEdicao!, livro);
      } else {
        await PrefsService.salvarLivro(livro);
      }
      await _carregarLivros();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_indiceEdicao != null ? 'Livro atualizado!' : 'Livro cadastrado!'),
        ),
      );
      _limparFormulario();
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  Future<void> _removerLivro(int indice) async {
    await PrefsService.removerLivro(indice);
    await _carregarLivros();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro excluído')),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _anoController.dispose();
    _avaliacaoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _blocoFormulario(),
              const SizedBox(height: 30),
              const Text(
                "Livros cadastrados",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _carregandoLista
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : _livros.isEmpty
                      ? const Text(
                          'Nenhum livro salvo ainda.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _livros.length,
                          itemBuilder: (context, index) {
                            final livro = _livros[index];
                            return CardLivro(
                              livro: livro,
                              onTap: () => Navigator.pushNamed(
                                context,
                                'detalhes',
                                arguments: livro,
                              ),
                              onEditar: () => _preencherFormulario(livro, indice: index),
                              onExcluir: () => _removerLivro(index),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blocoFormulario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _indiceEdicao != null ? "Editar Livro" : "Gerenciar Livros",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF7086EC)),
                  label: const Text(
                    "Voltar",
                    style: TextStyle(color: Color(0xFF7086EC), fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _campo(
              controller: _tituloController,
              label: "Título",
              validator: (v) => v == null || v.trim().isEmpty ? "Informe o título" : null,
            ),
            _campo(
              controller: _autorController,
              label: "Autor",
              validator: (v) => v == null || v.trim().isEmpty ? "Informe o autor" : null,
            ),
            _campo(
              controller: _anoController,
              label: "Ano de Publicação",
              tipoNumero: true,
              validator: (v) => v == null || v.trim().isEmpty ? "Informe o ano" : null,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                key: _generoKey,
                initialValue: _generoSelecionado,
                decoration: InputDecoration(
                  labelText: "Gênero",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _generos
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _generoSelecionado = value;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _avaliacaoController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: "Avaliação (1 a 5)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  final valor = int.tryParse(v ?? '');
                  if (valor == null) return "Informe uma avaliação";
                  if (valor < 1 || valor > 5) return "Use valores entre 1 e 5";
                  return null;
                },
              ),
            ),
            _campo(
              controller: _descricaoController,
              label: "Descrição",
              multiline: true,
              validator: (v) => v == null || v.trim().isEmpty ? "Informe a descrição" : null,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _limparFormulario,
                  child: const Text("Cancelar"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7086EC),
                  ),
                  onPressed: _salvando ? null : _salvarLivro,
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: _salvando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_indiceEdicao != null ? "Atualizar Livro" : "Salvar Livro"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    bool tipoNumero = false,
    bool multiline = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: tipoNumero ? TextInputType.number : TextInputType.text,
        maxLines: multiline ? 4 : 1,
        inputFormatters: tipoNumero ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
