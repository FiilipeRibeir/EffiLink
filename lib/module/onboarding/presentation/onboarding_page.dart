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

  bool _passwordEmpty = false;
  bool _confirmPasswordEmpty = false;
  bool _storeNameEmpty = false;
  bool _tokenEmpty = false;

  final UserService userService = UserService();
  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.white12],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Scrollable content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 27).add(
                  EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  _buildRoleDropdown(),
                  const SizedBox(height: 20),
                  if (_role != null) _buildPasswordFields(),
                  const SizedBox(height: 20),
                  if (_role == "Admin") _buildStoreField(),
                  if (_role == "Gerente" || _role == "Funcionário")
                    _buildTokenField(),
                  const SizedBox(height: 20),
                  if (_role != null) _buildCompleteRegistrationButton(),
                  const SizedBox(height: 20),
                  _buildCancelButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formulario do Role
  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Escolha sua função", style: TextStyle(color: Colors.black)),
        DropdownButton<String>(
          value: _role,
          hint: const Text("Selecione sua função"),
          items: ["Admin", "Gerente", "Funcionário"]
              .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _role = value;
              _passwordEmpty = false;
              _confirmPasswordEmpty = false;
            });
          },
        ),
      ],
    );
  }

  /// Formulário da senha
  Widget _buildPasswordFields() {
    return Column(
      children: [
        CupertinoTextField(
          controller: _passwordController,
          placeholder: "Digite sua senha",
          obscureText: true,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: _passwordEmpty ? Colors.red : Colors.transparent),
          ),
        ),
        const SizedBox(height: 20),
        CupertinoTextField(
          controller: _confirmPasswordController,
          placeholder: "Confirme sua senha",
          obscureText: true,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: _confirmPasswordEmpty ? Colors.red : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  /// Formulário da loja
  Widget _buildStoreField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nome da Loja",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        CupertinoTextField(
          controller: _storeNameController,
          placeholder: "Digite o nome da loja",
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: _storeNameEmpty ? Colors.red : Colors.transparent),
          ),
        ),
      ],
    );
  }

  /// Formulário do token
  Widget _buildTokenField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Insira o token fornecido pelo Admin",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        CupertinoTextField(
          controller: _tokenController,
          placeholder: "Digite o token",
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: _tokenEmpty ? Colors.red : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  /// Botão de Finalizar cadastro
  Widget _buildCompleteRegistrationButton() {
    return SizedBox(
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
    );
  }

  /// Botão de cancelar
  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
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
    );
  }

  void _completeRegistration() async {
    setState(() {
      _passwordEmpty = _passwordController.text.isEmpty;
      _confirmPasswordEmpty = _confirmPasswordController.text.isEmpty;
      _storeNameEmpty = _role == "Admin" && _storeNameController.text.isEmpty;
      _tokenEmpty = (_role == "Gerente" || _role == "Funcionário") &&
          _tokenController.text.isEmpty;
    });

    if (_passwordEmpty ||
        _confirmPasswordEmpty ||
        (_role == "Admin" && _storeNameEmpty) ||
        ((_role == "Gerente" || _role == "Funcionário") && _tokenEmpty)) {
      showErrorDialog(context, 'Erro', 'Preencha todos os campos obrigatórios');
      return;
    }
  }
}
