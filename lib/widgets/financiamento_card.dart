import 'package:flutter/material.dart';

import '../models/financiamento.dart';

class FinanciamentoCard extends StatelessWidget {
  final Financiamento financiamento;

  const FinanciamentoCard({
    super.key,
    required this.financiamento,
  });

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff355CFF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Color(0xff355CFF),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  dinheiro(financiamento.valor),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _informacao(
                  'Parcelas',
                  '${financiamento.parcelas}x',
                ),
                _informacao(
                  'Parcela',
                  dinheiro(financiamento.valorParcela),
                ),
                _informacao(
                  'Montante',
                  dinheiro(financiamento.montante),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Taxa mensal: ${financiamento.taxa.toStringAsFixed(2).replaceAll('.', ',')}%',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _informacao(
    String titulo,
    String valor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
