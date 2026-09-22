import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invertexto_api/service/invertexto_service.dart';

class BuscaCepPage extends StatefulWidget {
  const BuscaCepPage({super.key});

  @override
  State<BuscaCepPage> createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  String? campo;
  String? resultado;
  String? erroValidacao;
  final TextEditingController controller = TextEditingController();
  final apiService = InvertextoService();

  void buscar() {
    String value = controller.text;
    setState(() {
      if(value.isEmpty) {
        erroValidacao = "O campo CEP é obrigatorio";
        campo = null;
      } else if(value.length != 8) {
        erroValidacao = "O CEP precisa ter exatamente 8 digitos";
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/imgs/cep.jpg',
          fit: BoxFit.contain,
          height: 40,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Digite o CEP (somente números)",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                errorText: erroValidacao,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
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
                child: const Text("Buscar CEP"),
              ),
            ),
            SizedBox(height: 10),
            if(campo != null)
              FutureBuilder(
                future: apiService.buscaCep(campo),
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
                        final erro = snapshot.error.toString();
                        final json = jsonDecode(erro.substring(erro.indexOf('{')));
                        return Center(
                          child: Text(
                            json["message"],
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              )
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String enderecoCompleto = '';
    if(snapshot.data != null) {
      enderecoCompleto +=
      snapshot.data["street"] ?? "Rua nao disponivel.";
      enderecoCompleto += "\n";
      enderecoCompleto +=
      snapshot.data["neighborhood"] ?? "Bairro nao disponivel";
      enderecoCompleto += "\n";
      enderecoCompleto +=
      snapshot.data["city"] ?? "Cidade nao disponivel";
      enderecoCompleto += "\n";
      enderecoCompleto += 
      snapshot.data["state"] ?? "Estado nao disponivel";
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        enderecoCompleto,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
        softWrap: true,
      )
    );
  }
}