import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  State<PaginaRegistro> createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends State<PaginaRegistro> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _registrar() async {
    if (_formKey.currentState!.validate()) {
      await PrefsService.cadastrarUsuario(
        _emailController.text,
        _senhaController.text,
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado! Faça login.')),
      );
      Navigator.pop(context); // Volta para o login
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
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Criar Conta", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _registrar,
                    child: const Text("CADASTRAR", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Já tenho conta. Voltar."),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}