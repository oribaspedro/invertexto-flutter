import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invertexto_api/service/invertexto_service.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  String? campo;
  String? resultado;
  String? erroValidacao;
  final TextEditingController controller = TextEditingController();
  final apiService = InvertextoService();

  void buscar() {
    String value = controller.text;
    setState(() {
      if(value.isEmpty) {
        erroValidacao = "O campo número é obrigatório";
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
          'assets/imgs/numeros.png',
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
              labelText: "Digite um numero",
              labelStyle: TextStyle(color: Colors.white),
              errorText: erroValidacao,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
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
              child: const Text("Converter por extenso"),
            ),
          ),
          SizedBox(height: 10),
          if(campo != null)
            FutureBuilder(
              future: apiService.convertePorExtenso(campo),
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
            ),
        ],),
      ),
    );
  }

  Widget exibeResultado (BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        snapshot.data["text"] ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
        softWrap: true,
      ),
    );
  }
}