import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/login/login_form.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin { 
  late AnimationController _backgroundController;
  late AnimationController _heightController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _heightAnimation;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Animación de fondo
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100), // Mantener la duración de 100 segundos para la animación de fondo
    )..repeat(); // Sin reverse, para un movimiento continuo

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    // Animación para el cambio de altura del login form
    _heightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animación de altura más rápida
    );
    _heightAnimation = Tween<double>(begin: 10, end: 450).animate(
      CurvedAnimation(parent: _heightController, curve: Curves.easeInOut),
    );

    // Temporizador para esperar 3 segundos antes de iniciar la animación de altura
    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _heightController.forward(); // Iniciar animación de altura
      });
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _heightController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Ajustar el tamaño de los logos considerando el movimiento en diagonal
    final logoWidth = screenWidth * 0.3; // Ajustar al 30% del ancho de la pantalla
    final logoHeight = screenHeight * 0.3; // Ajustar al 30% de la altura de la pantalla

    // Calculamos la distancia diagonal entre los logos
    final diagonalDistance = sqrt(logoWidth * logoWidth + logoHeight * logoHeight); // Distancia diagonal

    // Añadir separación para asegurar que los logos no se toquen
    final separation = diagonalDistance * 0.7; // Aseguramos un poco más de separación

    return Scaffold(
      resizeToAvoidBottomInset: true, // Habilita ajuste al teclado
      backgroundColor: const Color.fromRGBO(88, 83, 163, 1),
      body: Stack(
        children: [
          // Fondo en movimiento infinito
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                // Offset en diagonal
                double offsetX = -screenWidth * _backgroundAnimation.value;
                double offsetY = -screenHeight * _backgroundAnimation.value;

                // Cálculo de la separación total considerando la diagonal
                double totalWidth = logoWidth + separation;
                double totalHeight = logoHeight + separation;

                return Stack(
                  children: [
                    for (int i = 0; i < 3; i++) // 3 repeticiones en cada fila
                      for (int j = 0; j < 3; j++) // 3 repeticiones en cada columna
                        Positioned(
                          left: offsetX + (i * totalWidth),
                          top: offsetY + (j * totalHeight),
                          child: SvgPicture.asset(
                            "assets/svg/logo_stroke.svg",
                            width: logoWidth,
                            height: logoHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                  ],
                );
              },
            ),
          ),

          // Contenido principal
          Center(
            child: SingleChildScrollView( // Aquí se añade el SingleChildScrollView
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/logo.svg",
                    width: 120,
                  ),
                  const SizedBox(height: 30),
                  AnimatedBuilder(
                    animation: _heightAnimation,
                    builder: (context, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500), // Duración de la animación
                        width: 320,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        height: _heightAnimation.value, // Animar la altura
                        child: const LoginForm(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
