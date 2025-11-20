import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class paginaModificacoes extends StatelessWidget {
  const paginaModificacoes({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de gêneros predefinidos
    final List<String> generos = [
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

    String generoSelecionado = generos[0]; // valor inicial do Dropdown

    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Formulário + Título + Botão Voltar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======== TÍTULO + BOTÃO VOLTAR NA MESMA LINHA ========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Gerenciar Livros",
                        style: TextStyle(
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

                  // ======== CAMPOS DO FORMULÁRIO ========
                  _campo("Título"),
                  _campo("Autor"),
                  _campo("Ano de Publicação", tipoNumero: true),

                  // Campo Gênero com Dropdown
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButtonFormField<String>(
                          value: generoSelecionado,
                          decoration: InputDecoration(
                            labelText: "Gênero",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: generos
                              .map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                generoSelecionado = value;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),

                  // Campo Avaliação 1 a 5
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(RegExp(r'[1-5]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Avaliação (1 a 5)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  _campo("Descrição", multiline: true),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7086EC),
                        ),
                        onPressed: () {},
                        child: const Text("Salvar Livro"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {},
                        child: const Text("Cancelar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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

            // Exemplo de livros cadastrados
            _livroItem("A Fundação", "Isaac Asimov"),
            _livroItem("Dom Casmurro", "Machado de Assis"),
            _livroItem("O Hobbit", "J. R. R. Tolkien"),
          ],
        ),
      ),
    );
  }

  // Widget Campo de Texto
  Widget _campo(String label, {bool tipoNumero = false, bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        keyboardType: tipoNumero ? TextInputType.number : TextInputType.text,
        maxLines: multiline ? 4 : 1,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Widget Item de Livro
  Widget _livroItem(String titulo, String autor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Infos do livro
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(autor),
            ],
          ),

          // Botões de ação
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Editar"),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Excluir",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
