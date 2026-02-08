import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marshall/widgets/bottomnavigations.dart';
import 'package:marshall/screens/homepage.dart';
import 'package:marshall/screens/sign_ui.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
        ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _colorAnimation =
        ColorTween(begin: Colors.green, end: Colors.red).animate(_controller);

    _controller.forward();

    playSplashSound();
    navigateToNext();
  }

  void playSplashSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('assets/audio/chittiintro.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUi()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 350,
                      child:Image(image: AssetImage("assets/icons/musiumicon.png"))
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Musium",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 35,
                        fontFamily: "dot",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
