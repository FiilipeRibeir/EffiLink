import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saas_crm/index.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String userType = 'Admin';
  final UserService userService = UserService();

  // Variáveis para armazenar mensagens de erro específicas
  String? nameError;
  String? emailError;
  String? passwordError;

  // Função para validar o email
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$");
    return emailRegex.hasMatch(email);
  }

  // Função para salvar o usuário
  Future<void> _createUser() async {
    setState(() {
      // Resetando mensagens de erro
      nameError = null;
      emailError = null;
      passwordError = null;
    });

    // Verifica se todos os campos foram preenchidos
    bool isValid = true;

    if (nameController.text.isEmpty) {
      nameError = "O nome não pode estar vazio.";
      isValid = false;
    }
    if (emailController.text.isEmpty) {
      emailError = "O email não pode estar vazio.";
      isValid = false;
    } else if (!_isEmailValid(emailController.text)) {
      emailError = "Insira um email válido (@gmail.com).";
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError = "A senha não pode estar vazia.";
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    final userData = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "role": userType,
    };

    try {
      await userService.createUser(userData);
      _showCenteredDialog("Usuário criado com sucesso!");
      context.go(LoginRouter.root);
    } catch (e) {
      _showCenteredDialog("Erro ao criar usuário: $e");
    }
  }

  // Função para exibir o diálogo no centro da tela
  void _showCenteredDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.white12,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Preencha os dados abaixo para criar uma conta.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: userType,
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    userType = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo de Usuário'),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  nameController, "Nome", "Digite seu nome", nameError),
              const SizedBox(height: 10),
              _buildTextField(
                  emailController, "Email", "Digite seu email", emailError),
              const SizedBox(height: 10),
              _buildTextField(passwordController, "Senha", "Digite sua senha",
                  passwordError,
                  obscureText: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(17),
                  color: Colors.greenAccent,
                  onPressed: _createUser,
                  child: const Text(
                    "Criar Conta",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  context.go(LoginRouter.root);
                },
              ),
              CupertinoButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  context.go(HomeRouter.root);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    String? errorText, {
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: CupertinoTextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            padding: const EdgeInsets.all(15),
            obscureText: obscureText,
            cursorColor: Colors.lightBlue,
            placeholder: hint,
            placeholderStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
