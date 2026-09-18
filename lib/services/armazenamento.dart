import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/financiamento.dart';

class Armazenamento {
  Future<void> salvar(
    Financiamento financiamento,
  ) async {
    final preferencias = await SharedPreferences.getInstance();

    final listaAtual = preferencias.getStringList(
          'financiamentos',
        ) ??
        [];

    listaAtual.add(
      jsonEncode(financiamento.toMap()),
    );

    await preferencias.setStringList(
      'financiamentos',
      listaAtual,
    );
  }

  Future<List<Financiamento>> buscar() async {
    final preferencias = await SharedPreferences.getInstance();

    final lista = preferencias.getStringList(
          'financiamentos',
        ) ??
        [];

    return lista.map((item) {
      final mapa = jsonDecode(item);

      return Financiamento.fromMap(mapa);
    }).toList();
  }

  Future<void> limpar() async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.remove('financiamentos');
  }
}
