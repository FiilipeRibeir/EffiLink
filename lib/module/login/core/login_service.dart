import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:saas_crm/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final String apiUrl = 'http://192.168.1.2:8080';
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      // Decodifica a resposta como UTF-8 antes de interpretar como JSON
      final utf8ResponseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(utf8ResponseBody);

      if (response.statusCode == 200) {
        // Confirma se existe um campo 'user' para considerar como sucesso
        if (responseData.containsKey('user')) {
          print('Usuário criado com sucesso: ${responseData['user']['id']}');
          return responseData; // Sucesso com o objeto 'user'
        } else if (responseData['message'] ==
            "✅Usuario Registrado com sucesso") {
          // Se não há 'user', mas a mensagem é de sucesso, retorne como sucesso
          print(responseData['message']); // Confirmação no log
          return {'status': 'success', 'message': responseData['message']};
        } else {
          throw Exception("Resposta inesperada: $utf8ResponseBody");
        }
      } else {
        // Em caso de status de erro, mostra a mensagem de erro específica
        print('Erro ao criar usuário: ${responseData['message']}');
        return {'status': 'error', 'message': responseData['message']};
      }
    } catch (e) {
      print("Erro ao criar usuário: $e");
      return {'status': 'error', 'message': "Erro ao criar usuário: $e"};
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      // Chama a função que retorna todos os usuários
      final List<UserGetAll> users = await getAllUsers();

      print("Usuários retornados: $users"); // Verifique o que está retornando

      // Procura o usuário pelo e-mail
      for (var user in users) {
        if (user.email == email) {
          return true; // Se encontrar, retorna true
        }
      }

      return false; // Se não encontrar, retorna false
    } catch (e) {
      print('Erro ao verificar se o usuário existe: $e');
      throw Exception('Erro ao verificar usuário');
    }
  }

  Future<List<UserGetAll>> getAllUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/users/getall'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['users'];
      return data.map((userJson) => UserGetAll.fromJson(userJson)).toList();
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  Future<AuthResponse> googleSignIn() async {
    const webClientId =
        '705259620246-2q6g55criejhcba4m9fvpo1l2f1nm5ia.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId:
          webClientId, // Defina o Client ID da sua configuração no Google
    );

    try {
      // Verifica se o usuário já está autenticado com o Google
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Usuário cancelou o login do Google.';
      }

      // Se o usuário não estiver autenticado, força a exibição da tela de escolha de conta
      // Isso pode ser necessário caso o login automático esteja pulando a escolha de conta
      await googleSignIn
          .signInSilently(); // Garante que o usuário será forçado a fazer login.

      // Obtém os tokens de autenticação
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      // Usando o Supabase para autenticação com o ID Token e Access Token
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      // Em caso de erro, podemos lançar uma exceção ou retornar um erro customizado
      print("Erro ao tentar logar com Google: $e");
      throw Exception("Falha ao autenticar com Google: $e");
    }
  }

  Future<Map<String, dynamic>> createStore(String storeName) async {
    try {
      // Tentando inserir a loja
      final response = await supabase
          .from('stores') // A tabela onde você está criando a loja
          .insert({'name': storeName})
          .select() // Seleciona os dados após a criação
          .single(); // Espera um único objeto, ou seja, a loja criada

      // Verificar se a resposta tem o campo 'id'
      if (response['id'] != null) {
        print("Loja criada: ${response['id']}"); // Log para verificar o ID
        return response; // Retorna a resposta
      } else {
        throw Exception("ID da loja não retornado ou resposta inválida.");
      }
    } catch (e) {
      // Em caso de erro, logar e lançar a exceção
      print("Erro ao criar loja: $e");
      throw Exception("Erro ao criar loja: $e");
    }
  }
}
