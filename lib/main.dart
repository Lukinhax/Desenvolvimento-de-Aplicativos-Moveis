import 'package:flutter/material.dart';
import 'package:catalogo_filmes/telas/home.dart';
import 'package:catalogo_filmes/telas/modificacao.dart';
import 'package:catalogo_filmes/telas/detalhes.dart';
import 'package:catalogo_filmes/telas/login.dart'; // Importe
import 'package:catalogo_filmes/telas/registro.dart'; // Importe

void main() {
  runApp(const MeuAppCatalogo());
}

class MeuAppCatalogo extends StatelessWidget {
  const MeuAppCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Livros',
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        useMaterial3: false,
      ),
      themeMode: ThemeMode.system,

       // Rota inicial agora é o Login
       initialRoute: '/',

       routes: {
        '/': (context) => const PaginaLogin(), 
        'registro': (context) => const PaginaRegistro(),
        'home': (context) => const PaginaHome(),
        'modificacoes': (context) => const PaginaModificacoes(),
        'detalhes': (context) => const PaginaDetalhes(),
        }
     );
  }
}