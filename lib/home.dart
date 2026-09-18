import 'package:flutter/material.dart';

import 'simulacao.dart';
import 'splash.dart';
import 'widgets/financiamento_card.dart';
import 'models/financiamento.dart';
import 'services/armazenamento.dart';

class Home extends StatefulWidget {
  final VoidCallback trocarTema;
  final bool temaEscuro;

  const Home({
    super.key,
    required this.trocarTema,
    required this.temaEscuro,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Armazenamento armazenamento = Armazenamento();

  List<Financiamento> financiamentos = [];

  @override
  void initState() {
    super.initState();
    carregarFinanciamentos();
  }

  Future<void> carregarFinanciamentos() async {
    final lista = await armazenamento.buscar();

    setState(() {
      financiamentos = lista;
    });
  }

  void abrirSimulacao() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Simulacao(
          atualizar: carregarFinanciamentos,
        ),
      ),
    );
  }

  void abrirSplash() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Splash(
          trocarTema: widget.trocarTema,
          temaEscuro: widget.temaEscuro,
        ),
      ),
    );
  }

  void sair() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text(
            'Deseja realmente fechar o aplicativo?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // O encerramento real pode ser feito
                // no emulador/dispositivo Android.
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FinanSim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.trocarTema,
            icon: Icon(
              widget.temaEscuro ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              color: const Color(0xff355CFF),
              padding: const EdgeInsets.all(24),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 45,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'FinanSim',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Simulador de financiamentos',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Nova simulação'),
              onTap: () {
                Navigator.pop(context);
                abrirSimulacao();
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Alterar tema'),
              onTap: () {
                widget.trocarTema();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Splash'),
              onTap: () {
                Navigator.pop(context);
                abrirSplash();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: const Text('Sair'),
              onTap: sair,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: financiamentos.isEmpty
            ? _semFinanciamentos()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minhas simulações',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Acompanhe seus financiamentos simulados.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: ListView.builder(
                      itemCount: financiamentos.length,
                      itemBuilder: (context, index) {
                        return FinanciamentoCard(
                          financiamento: financiamentos[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirSimulacao,
        backgroundColor: const Color(0xff355CFF),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _semFinanciamentos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xff355CFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calculate_outlined,
              size: 70,
              color: Color(0xff355CFF),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhuma simulação ainda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clique no botão + para começar.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
