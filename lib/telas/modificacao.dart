import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/livro.dart';
import '../services/prefs_service.dart';

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

  // CORREÇÃO 1: Removido 'const' para permitir adicionar gêneros da API
  List<String> _generos = [
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
  bool _salvando = false;
  int? _indiceEdicao;
  bool _argsProcessados = false;

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

  void _preencherFormulario(Livro livro, {int? indice}) {
    // CORREÇÃO 2: Adiciona o gênero à lista se ele não existir (evita erro do Dropdown)
    if (!_generos.contains(livro.genero)) {
      setState(() {
        _generos.add(livro.genero);
      });
    }

    setState(() {
      _tituloController.text = livro.titulo;
      _autorController.text = livro.autor;
      _anoController.text = livro.anoPublicacao.toString();
      _generoSelecionado = livro.genero; 
      _avaliacaoController.text = livro.avaliacao.toString();
      _descricaoController.text = livro.descricao;
      _indiceEdicao = indice;
    });
    
    // Atualiza visualmente o Dropdown com o novo valor
    if (_generoKey.currentState != null) {
       _generoKey.currentState!.didChange(_generoSelecionado);
    }
  }

  // CORREÇÃO 3: Função _limparFormulario removida pois não era usada.

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
      // Mantém a imagem original se estiver editando, ou null se for novo
      imagemCapa: null, 
    );

    setState(() => _salvando = true);
    try {
      if (_indiceEdicao != null) {
        await PrefsService.atualizarLivro(_indiceEdicao!, livro);
      } else {
        await PrefsService.salvarLivro(livro);
      }
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_indiceEdicao != null ? 'Livro atualizado!' : 'Livro cadastrado!')),
      );
      Navigator.pop(context); // Volta para a Home após salvar
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
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
      appBar: AppBar(
        title: Text(_indiceEdicao != null ? "Editar Livro" : "Novo Livro"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
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
                      value: _generoSelecionado, 
                      decoration: InputDecoration(
                        labelText: "Gênero",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _generos.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _generoSelecionado = value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _avaliacaoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Avaliação (1 a 5)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        final valor = int.tryParse(v ?? '');
                        if (valor == null || valor < 1 || valor > 5) return "Entre 1 e 5";
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
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7086EC)),
                      onPressed: _salvando ? null : _salvarLivro,
                      child: _salvando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(_indiceEdicao != null ? "Atualizar" : "Salvar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }
}