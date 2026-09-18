import 'package:flutter/material.dart';

import 'models/financiamento.dart';
import 'services/banco_central.dart';
import 'services/armazenamento.dart';

class Simulacao extends StatefulWidget {
  final VoidCallback atualizar;

  const Simulacao({
    super.key,
    required this.atualizar,
  });

  @override
  State<Simulacao> createState() => _SimulacaoState();
}

class _SimulacaoState extends State<Simulacao> {
  final TextEditingController valorController = TextEditingController();

  final TextEditingController parcelasController = TextEditingController();

  final BancoCentral bancoCentral = BancoCentral();
  final Armazenamento armazenamento = Armazenamento();

  double taxa = 0;
  double montante = 0;
  double valorParcela = 0;

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarTaxa();
  }

  Future<void> buscarTaxa() async {
    try {
      final valor = await bancoCentral.buscarTaxa();

      setState(() {
        taxa = valor;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível buscar a taxa do Banco Central.',
          ),
        ),
      );
    }
  }

  void calcular() {
    double? valor = double.tryParse(
      valorController.text.replaceAll(',', '.'),
    );

    int? parcelas = int.tryParse(
      parcelasController.text,
    );

    if (valor == null || parcelas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha os campos corretamente.',
          ),
        ),
      );
      return;
    }

    if (valor <= 0 || parcelas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe valores maiores que zero.',
          ),
        ),
      );
      return;
    }

    double juros = taxa / 100;

    double resultado = valor * pow(1 + juros, parcelas);

    setState(() {
      montante = resultado;
      valorParcela = resultado / parcelas;
    });
  }

  double pow(double base, int expoente) {
    double resultado = 1;

    for (int i = 0; i < expoente; i++) {
      resultado *= base;
    }

    return resultado;
  }

  Future<void> salvar() async {
    double? valor = double.tryParse(
      valorController.text.replaceAll(',', '.'),
    );

    int? parcelas = int.tryParse(
      parcelasController.text,
    );

    if (valor == null || parcelas == null || montante == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Faça uma simulação antes de salvar.',
          ),
        ),
      );
      return;
    }

    final financiamento = Financiamento(
      valor: valor,
      parcelas: parcelas,
      taxa: taxa,
      montante: montante,
      valorParcela: valorParcela,
    );

    await armazenamento.salvar(financiamento);

    widget.atualizar();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Simulação salva com sucesso!',
        ),
      ),
    );

    Navigator.pop(context);
  }

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  void dispose() {
    valorController.dispose();
    parcelasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova simulação'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Simule seu financiamento',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Informe o valor e a quantidade de parcelas.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: valorController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Valor desejado',
                hintText: 'Ex.: 10000',
                prefixIcon: const Icon(
                  Icons.attach_money,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: parcelasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de parcelas',
                hintText: 'Ex.: 24',
                prefixIcon: const Icon(
                  Icons.calendar_month,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff355CFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance,
                    color: Color(0xff355CFF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Taxa mensal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          carregando
                              ? 'Buscando no Banco Central...'
                              : '${taxa.toStringAsFixed(2).replaceAll('.', ',')}% ao mês',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: carregando ? null : calcular,
                icon: const Icon(Icons.calculate),
                label: const Text(
                  'CALCULAR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (montante > 0) _resultado(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: montante > 0 ? salvar : null,
                icon: const Icon(Icons.save),
                label: const Text(
                  'SALVAR SIMULAÇÃO',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultado() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Color(0xff355CFF),
                ),
                SizedBox(width: 10),
                Text(
                  'Resultado',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Montante'),
                Text(
                  dinheiro(montante),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Valor da parcela'),
                Text(
                  dinheiro(valorParcela),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff355CFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
