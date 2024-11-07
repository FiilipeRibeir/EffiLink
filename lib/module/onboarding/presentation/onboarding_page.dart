import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saas_crm/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  String? _role;
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  final UserService userService = UserService();

  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/effilink.png",
          width: 100,
        ),
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.white12,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Complete seu cadastro",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            // Campo para escolher o role
            const Text("Escolha sua função",
                style: TextStyle(color: Colors.black)),
            DropdownButton<String>(
              value: _role,
              hint: const Text(
                "Selecione sua função",
              ),
              items: ["Admin", "Gerente", "Funcionário"]
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _role = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Campo de senha
            CupertinoTextField(
              controller: _passwordController,
              placeholder: "Digite sua senha",
              obscureText: true,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de confirmação de senha
            CupertinoTextField(
              controller: _confirmPasswordController,
              placeholder: "Confirme sua senha",
              obscureText: true,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(height: 20),
            // Se for Admin, mostrar campo para criar loja
            if (_role == "Admin") ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nome da Loja",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  CupertinoTextField(
                    controller: _storeNameController,
                    placeholder: "Digite o nome da loja",
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
            // Se for Gerente ou Funcionário, mostrar campo para inserir token
            if (_role == "Gerente" || _role == "Funcionário") ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Insira o token fornecido pelo Admin",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  CupertinoTextField(
                    controller: _tokenController,
                    placeholder: "Digite o token",
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            // Botão para completar cadastro
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Colors.greenAccent,
                onPressed: _completeRegistration,
                child: const Text(
                  "Finalizar cadastro",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                onPressed: () {
                  context.go("/login");
                },
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeRegistration() async {
    try {
      final fullName = user?.userMetadata?['full_name'] ?? 'Nome Desconhecido';
      final email = user?.email ?? 'Email Desconhecido';

      if (_passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha ambos os campos de senha')),
        );
        return;
      }

      // Se o role for Admin, cria uma loja e recebe o store_id
      String? storeId;
      if (_role == "Admin") {
        final storeName = _storeNameController.text;
        final store =
            await userService.createStore(storeName); // Agora esperamos um Map
        storeId = store['id']; // Aqui você recebe o ID da loja criada
      }

      // Verifique se o storeId está correto antes de criar o usuário
      if (_role == "Admin" && storeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: O ID da loja não foi gerado')),
        );
        return;
      }

      // Criar o usuário no backend com o store_id
      await userService.createUser({
        'name': fullName,
        'email': email,
        'password': _passwordController.text,
        'role': _role!,
        'token': _tokenController.text, // Apenas se Gerente ou Funcionário
        'store_id': storeId, // Envia o store_id, caso tenha sido criado
      });

      // Redirecionar para a tela principal
      context.go(HomeRouter.root);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao completar cadastro: $e')),
      );
    }
  }
}
