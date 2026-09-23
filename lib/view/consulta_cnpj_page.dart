import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invertexto_api/service/invertexto_service.dart';

class ConsultaCnpjPage extends StatefulWidget {
  const ConsultaCnpjPage({super.key});

  @override
  State<ConsultaCnpjPage> createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  String? campo;
  String? resultado;
  String? erroValidacao;
  final TextEditingController controller = TextEditingController();
  final apiService = InvertextoService();

  void buscar() {
    String value = controller.text;
    setState(() {
      if(value.isEmpty) {
        erroValidacao = "O campo CNPJ é obrigatorio";
        campo = null;
      } else if(value.length != 14) {
        erroValidacao = "O CNPJ precisa ter exatamente 14 caracteres";
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
          'assets/imgs/cnpj.png',
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
              labelText: "CNPJ (somente números e letras)",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              errorText: erroValidacao,
            ),
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
            onSubmitted: (value) {
              buscar();
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: buscar,
              child: const Text("Consultar CNPJ"),
            ),
          ),
          const SizedBox(height: 10),
          if(campo != null)
            FutureBuilder(
              future: apiService.consultaCnpj(campo),
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
                          mensagemErro = "Falha na conexão com o servidor";
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
    String respostaCompleta = '';
    if(snapshot.data != null) {
      respostaCompleta += "Razão Social: ";
      respostaCompleta +=
      snapshot.data["razao_social"] ?? "Não disponível.";
      respostaCompleta += "\n";
      respostaCompleta += "Nome Fantasia: ";
      respostaCompleta +=
      snapshot.data["nome_fantasia"] ?? "Não disponível";
      respostaCompleta += "\n";
      respostaCompleta += "Natureza Juridica: ";
      respostaCompleta +=
      snapshot.data["natureza_juridica"] ?? "Não disponivel";
      respostaCompleta += "\n";
      respostaCompleta += "Capital Social: ";
      respostaCompleta += 
      snapshot.data["capital_social"] ?? "Não disponivel";
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        respostaCompleta,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
        softWrap: true,
      ),
    );
  }
}