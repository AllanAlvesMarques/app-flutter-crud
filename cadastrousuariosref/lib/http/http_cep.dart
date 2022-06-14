import 'dart:convert';
import 'package:cadastrousuariosref/models/http_cep_model.dart';
import 'package:http/http.dart' as http;

Future<HttpCepModel> buscarCepContato(String cep) async {
  final url = 'https://viacep.com.br/ws/$cep/json/';
  var response = await http.get(Uri.parse(url));
  HttpCepModel httpCep;
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    httpCep = HttpCepModel(
        logradouro: json['logradouro'],
        bairro: json['bairro'],
        localidade: json['localidade'],
        complemento: json['complemento'],
        uf: json['uf']);
  } else {
    httpCep = HttpCepModel();
  }
  return httpCep;
}
