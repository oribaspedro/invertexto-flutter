import 'package:flutter/material.dart';
import 'package:invertexto_api/service/invertexto_service.dart';

class GeraPessoaPage extends StatefulWidget {
  const GeraPessoaPage({super.key});

  @override
  State<GeraPessoaPage> createState() => _GeraPessoaPageState();
}

class _GeraPessoaPageState extends State<GeraPessoaPage> {
  bool botaoPressionado = false;
  String? resultado;
  final apiService = InvertextoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/imgs/pessoa.png',
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
        child: Center(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      botaoPressionado = true;
                    });
                  },
                  child: const Text('Gerar pessoa'),
                ),
              ),
              SizedBox(height: 10),
              if(botaoPressionado)
                FutureBuilder(
                  future: apiService.geraPessoa(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 5.0,
                        );
                      default:
                        botaoPressionado = false;
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erro ao buscar os dados.',
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
        )
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String respostaCompleta = '';
    if (snapshot.data != null) {
      respostaCompleta += "Nome: ";
      respostaCompleta += snapshot.data["name"] ?? "Não disponível.";
      respostaCompleta += "\n";
      respostaCompleta += "Cpf: ";
      respostaCompleta += snapshot.data["cpf"] ?? "Não disponível";
      respostaCompleta += "\n";
      respostaCompleta += "Data de nascimento: ";
      respostaCompleta += snapshot.data["birth_date"] ?? "Não disponivel";
      respostaCompleta += "\n";
      respostaCompleta += "Email: ";
      respostaCompleta += snapshot.data["email"] ?? "Não disponivel";
      respostaCompleta += "\n";
      respostaCompleta += "Telefone: ";
      respostaCompleta += snapshot.data["phone_number"] ?? "Não disponivel";
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        respostaCompleta,
        style: TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
