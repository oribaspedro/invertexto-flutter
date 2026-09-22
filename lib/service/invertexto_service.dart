import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class InvertextoService {
  final String _token = '28248|hjQTJ7ROz6eRJftuOwEZT7UeUDNdZ13A';

  Future<Map<String, dynamic>> convertePorExtenso (String? valor) async {
    try {
      final uri = Uri.parse(
        'https://api.invertexto.com/v1/number-to-words'
        '?token=$_token&number=$valor'
        '&language=pt'
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      else {
        throw Exception(
          'Erro ${response.statusCode}: ${response.body}'
        );
      }
    } on SocketException {
      throw Exception('Erro de conexao com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCep (String? valor) async {
    try {
      final uri = Uri.parse(
        'https://api.invertexto.com/v1/cep/$valor'
        '?token=$_token'
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      else {
        throw Exception(
          'Erro ${response.statusCode}: ${response.body}'
        );
      }
    } on SocketException {
      throw Exception('Erro de conexao com a internet');
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> validaEmail (String? valor) async {
    try {
      final uri = Uri.parse(
        'https://api.invertexto.com/v1/email-validator/$valor'
        '?token=$_token'
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      else {
        throw Exception(
          'Erro ${response.statusCode}: ${response.body}'
        );
      }
    } on SocketException {
      throw Exception('Erro de conexao com a internet');
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> consultaCnpj (String? valor) async {
    try {
      final uri = Uri.parse(
        'https://api.invertexto.com/v1/cnpj/$valor'
        '?token=$_token'
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      else {
        throw Exception(
          'Erro ${response.statusCode}: ${response.body}'
        );
      }
    } on SocketException {
      throw Exception('Erro de conexao com a internet');
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> geraPessoa () async {
    try {
      final uri = Uri.parse(
        'https://api.invertexto.com/v1/faker/'
        '?token=$_token'
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      else {
        throw Exception(
          'Erro ${response.statusCode}: ${response.body}'
        );
      }
    } on SocketException {
      throw Exception('Erro de conexao com a internet');
    } catch (e) {
      rethrow;
    }
  }
}