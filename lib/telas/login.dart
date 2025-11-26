import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      bool sucesso = await PrefsService.login(
        _emailController.text,
        _senhaController.text,
      );

      if (!mounted) return;

      if (sucesso) {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email ou senha inválidos!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7086EC),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: 400, // Largura fixa boa para Web
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Bem-vindo", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Digite o email" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Digite a senha" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7086EC)),
                    onPressed: _fazerLogin,
                    child: const Text("ENTRAR", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, 'registro'),
                  child: const Text("Não tem conta? Cadastre-se"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}