import 'dart:convert'; // Importe o pacote dart:convert
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Appviacep());

class Appviacep extends StatelessWidget {
  const Appviacep({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController cepController = TextEditingController();
  String result = "";

  Future<void> consultarCEP() async {
    String cep = cepController.text;
    try {
      final response =
          await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("erro")) {
          setState(() {
            result = "CEP não encontrado.";
          });
        } else {
          String address = "CEP: $cep\n"
              "Logradouro: ${data["logradouro"]}\n"
              "Bairro: ${data["bairro"]}\n"
              "Cidade: ${data["localidade"]}\n"
              "Estado: ${data["uf"]}";

          setState(() {
            result = address;
          });
        }
      } else {
        setState(() {
          result = "Falha ao carregar os dados do CEP.";
        });
      }
    } catch (e) {
      setState(() {
        result = "Erro ao consultar o CEP: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appviacep"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Digite o CEP"),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: consultarCEP,
              child: const Text("Consultar CEP"),
            ),
            const SizedBox(height: 20.0),
            Text(
              result,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
