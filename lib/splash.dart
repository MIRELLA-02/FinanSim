import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  final VoidCallback trocarTema;
  final bool temaEscuro;

  const Splash({
    super.key,
    required this.trocarTema,
    required this.temaEscuro,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> entrada;
  late Animation<double> saida;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    entrada = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    saida = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.7,
          1,
          curve: Curves.easeIn,
        ),
      ),
    );

    controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            trocarTema: widget.trocarTema,
            temaEscuro: widget.temaEscuro,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff355CFF),
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(
              opacity: controller.value < 0.7 ? entrada.value : saida.value,
              child: Transform.scale(
                scale: 0.7 + (entrada.value * 0.3),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xff355CFF),
                  size: 55,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'FinanSim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Simule. Planeje. Realize.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
