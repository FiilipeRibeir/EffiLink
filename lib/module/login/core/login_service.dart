import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:saas_crm/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final String apiUrl = Config.apiUrl;
  final SupabaseClient supabase = Supabase.instance.client;

  /// Cria um novo usuário com os dados fornecidos em `userData`.
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      return _handleResponse(response,
          successMessage: 'Usuário criado com sucesso.');
    } catch (e) {
      return _handleError("Erro ao criar usuário", e);
    }
  }

  /// Verifica se um usuário com o e-mail fornecido já existe.
  Future<bool> checkIfUserExists(String email) async {
    try {
      final users = await getAllUsers();
      return users.any((user) => user.email == email);
    } catch (e) {
      print('Erro ao verificar se o usuário existe: $e');
      throw Exception('Erro ao verificar usuário');
    }
  }

  /// Retorna todos os usuários.
  Future<List<UserGetAll>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/users/getall'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return (responseData['users'] as List)
            .map((userJson) => UserGetAll.fromJson(userJson))
            .toList();
      } else {
        throw Exception('Falha ao carregar usuários');
      }
    } catch (e) {
      throw Exception("Erro ao obter usuários: $e");
    }
  }

  Future<AuthResponse> googleSignIn() async {
    const webClientId = Config.googleClientId;
    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    try {
      // Desconecta qualquer usuário que possa estar logado para forçar a exibição da tela de seleção
      await googleSignIn.signOut();

      // Inicia o processo de login para abrir a tela de seleção de conta
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw 'Usuário cancelou o login do Google.';

      final googleAuth = await googleUser.authentication;

      // Autentica no Supabase usando os tokens obtidos
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      return response;
    } catch (e) {
      print("Erro ao tentar logar com Google: $e");
      throw Exception("Falha ao autenticar com Google: $e");
    }
  }

  /// Cria uma loja com o nome fornecido.
  Future<Map<String, dynamic>> createStore(String storeName) async {
    try {
      final response = await supabase
          .from('stores')
          .insert({'name': storeName})
          .select()
          .single();
      if (response['id'] == null) {
        throw Exception("ID da loja não retornado ou resposta inválida.");
      }

      print("Loja criada: ${response['id']}");
      return response;
    } catch (e) {
      return _handleError("Erro ao criar loja", e);
    }
  }

  /// Trata a resposta HTTP e retorna o JSON em caso de sucesso.
  Map<String, dynamic> _handleResponse(http.Response response,
      {required String successMessage}) {
    final utf8ResponseBody = utf8.decode(response.bodyBytes);
    final responseData = jsonDecode(utf8ResponseBody);

    if (response.statusCode == 200 && responseData.containsKey('user')) {
      print(successMessage);
      return responseData;
    } else if (response.statusCode == 200 &&
        responseData['message'] == "✅Usuario Registrado com sucesso") {
      print(responseData['message']);
      return {'status': 'success', 'message': responseData['message']};
    } else {
      throw Exception("Resposta inesperada: $utf8ResponseBody");
    }
  }

  /// Trata erros e retorna um mapa de erro.
  Map<String, dynamic> _handleError(String contextMessage, dynamic e) {
    print("$contextMessage: $e");
    return {'status': 'error', 'message': "$contextMessage: $e"};
  }
}
