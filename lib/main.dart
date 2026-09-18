import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash.dart';

void main() {
  runApp(const FinanSim());
}

class FinanSim extends StatefulWidget {
  const FinanSim({super.key});

  @override
  State<FinanSim> createState() => _FinanSimState();
}

class _FinanSimState extends State<FinanSim> {
  ThemeMode tema = ThemeMode.light;

  void trocarTema() {
    setState(() {
      if (tema == ThemeMode.light) {
        tema = ThemeMode.dark;
      } else {
        tema = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinanSim',
      themeMode: tema,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xffF5F7FB),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff355CFF),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff355CFF),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff101522),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff1B2742),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff355CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: Splash(
        trocarTema: trocarTema,
        temaEscuro: tema == ThemeMode.dark,
      ),
    );
  }
}
