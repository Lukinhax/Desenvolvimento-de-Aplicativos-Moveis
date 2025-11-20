import 'package:flutter/material.dart';

class PaginaHome extends StatelessWidget {
  const PaginaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),

      body: Column(
        children: [
          const SizedBox(height: 50),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 120,
              width: 620,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
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
                    ),
                  ),

                  // ===== BOTÃO COM TEXTO + ÍCONE =====
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7086EC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 25,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'modificacoes');
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Adicionar livro",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          
        ],
      ),
    );
  }
}

