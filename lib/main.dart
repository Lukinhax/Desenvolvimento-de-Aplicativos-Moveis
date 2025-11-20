import 'package:flutter/material.dart';
import 'package:catalogo_filmes/telas/home.dart';
import 'package:catalogo_filmes/telas/modificacao.dart';
import 'package:catalogo_filmes/telas/detalhes.dart';


void main() {
  runApp(const MeuAppCatalogo());
}

class MeuAppCatalogo extends StatelessWidget {
  const MeuAppCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Widget que implementa o Material Design do Google
      title: 'Catálogo de Livros', // titulo 

      theme: ThemeData(
        primarySwatch: Colors.blue, 
        useMaterial3: false,
      ),

      themeMode: ThemeMode.system, // usa o tema do celular

       initialRoute: '/', // rota inicial, a primeira que será aberta quando o sistema rodar

       routes: { // conjunto de rotas 
        '/': (context) => const PaginaHome(), // tela home
        'modificacoes': (context) => const paginaModificacoes(), // tela de modificações 
        'detalhes': (context) => const paginaDetalhes(), // tela de detalhes
        }

     );
  }
}