import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invertexto_api/service/invertexto_service.dart';

class ValidaEmailPage extends StatefulWidget {
  const ValidaEmailPage({super.key});

  @override
  State<ValidaEmailPage> createState() => _ValidaEmailPageState();
}

class _ValidaEmailPageState extends State<ValidaEmailPage> {
  String? campo;
  String? resultado;
  String? erroValidacao;
  final TextEditingController controller = TextEditingController();
  final apiService = InvertextoService();

  void buscar() {
    String value = controller.text;
    setState(() {
      if(value.isEmpty) {
        erroValidacao = "O campo Email é obrigatorio";
        campo = null;
      } else {
        erroValidacao = null;
        campo = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/imgs/email.png',
          fit: BoxFit.contain,
          height: 40,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              errorText: erroValidacao,
            ),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
            onSubmitted: (value) {
              buscar();
            }
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: buscar,
              child: Text("Validar email"),
            ),
          ),
          SizedBox(height: 10),
          if(campo != null)
            FutureBuilder(
              future: apiService.validaEmail(campo),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white
                      ),
                      strokeWidth: 5.0,
                    );
                  default:
                    if(snapshot.hasError) {
                      String mensagemErro = "Ocorreu um erro inesperado";
                      final erro = snapshot.error.toString();

                      try {
                        if(erro.contains('{')) {
                          final json = jsonDecode(erro.substring(erro.indexOf('{')));
                          mensagemErro = json["message"] ?? mensagemErro;
                        } else {
                          mensagemErro = "Nao foi possivel estabelecer uma conexao com o servidor";
                        }
                      } catch(e) {
                        mensagemErro = "Falha na conexão com o servidor";
                      }
                      return Center(
                        child: Text(
                          mensagemErro,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return exibeResultado(context, snapshot);
                    }
                }
              },
            ),
        ],),
      ),
    );
  }

  Widget exibeResultado (BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: [
        Text(
          snapshot.data["valid_format"] ? "O email é valido" : "O email não é valido",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
          softWrap: true,
        ),
        Text(
          snapshot.data["valid_mx"] ? "O domínio do email existe" : "O domínio do email não existe",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
          softWrap: true,
        ),
      ]
      
    );
  }
}