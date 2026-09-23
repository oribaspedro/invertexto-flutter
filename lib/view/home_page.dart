import 'package:flutter/material.dart';
import 'package:invertexto_api/view/busca_cep_page.dart';
import 'package:invertexto_api/view/consulta_cnpj_page.dart';
import 'package:invertexto_api/view/gera_pessoa.dart';
import 'package:invertexto_api/view/por_extenso_page.dart';
import 'package:invertexto_api/view/valida_email_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            )
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(width: 30),
                Text(
                  'Por extenso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PorExtensoPage()
                )
              );
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.maps_home_work,
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(width: 30),
                Text(
                  'Buscador de CEP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuscaCepPage()
                )
              );
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(width: 30),
                Text(
                  'Validador de email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ValidaEmailPage()
                )
              );
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.work,
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(width: 30),
                Text(
                  'Consulta de CNPJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsultaCnpjPage()
                )
              );
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(width: 30),
                Text(
                  'Gerador de pessoas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeraPessoaPage()
                )
              );
            },
          )
        ],),  
      ),
    );
  }
}