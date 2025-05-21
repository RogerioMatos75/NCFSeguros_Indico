import 'package:flutter/material.dart';

class NewModernLoginScreen extends StatelessWidget {
  const NewModernLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // Coluna da Esquerda (pode ser uma imagem ou cor de fundo)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey[700], // Cor de exemplo para o fundo
              child: const Center(
                child: Text(
                  'NCF Seguros',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          // Coluna da Direita (Formulário de Login)
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Faça login para continuar',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Campo de Email
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'seuemail@exemplo.com',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // Campo de Senha
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Sua senha',
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // TODO: Adicionar sufixo para mostrar/ocultar senha
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implementar lógica de "Esqueci minha senha"
                      },
                      child: const Text('Esqueceu sua senha?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Botão de Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implementar lógica de login
                    },
                    child: const Text('ENTRAR', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Não tem uma conta?'),
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar navegação para tela de criação de conta
                        },
                        child: const Text('Crie uma aqui'),
                      ),
                    ],
                  ),
                  // TODO: Adicionar opções de login social (Google, Facebook, etc.) se necessário
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}