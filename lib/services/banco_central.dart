import 'dart:convert';

import 'package:http/http.dart' as http;

class BancoCentral {
  Future<double> buscarTaxa() async {
    final agora = DateTime.now();

    String mes = agora.month.toString().padLeft(2, '0');
    String ano = agora.year.toString();

    String dataInicial = '01/$mes/$ano';
    String dataFinal = '${_ultimoDiaMes(agora)}/$mes/$ano';

    final url = Uri.parse(
      'https://api.bcb.gov.br/dados/serie/bcdata.sgs.4390/dados'
      '?formato=json'
      '&dataInicial=$dataInicial'
      '&dataFinal=$dataFinal',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados.isNotEmpty) {
        String valor = dados.last['valor'].toString();

        valor = valor.replaceAll(',', '.');

        return double.parse(valor);
      }
    }

    throw Exception('Não foi possível buscar a taxa.');
  }

  String _ultimoDiaMes(DateTime data) {
    DateTime ultimo = DateTime(
      data.year,
      data.month + 1,
      0,
    );

    return ultimo.day.toString().padLeft(2, '0');
  }
}
