import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:lastpractice/loginscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ZoomOutImageWithText(),
      ),
    );
  }
}

class ZoomOutImageWithText extends StatefulWidget {
  const ZoomOutImageWithText({super.key});

  @override
  State<ZoomOutImageWithText> createState() => _ZoomOutImageWithTextState();
}

class _ZoomOutImageWithTextState extends State<ZoomOutImageWithText> {
  double _scale = 1.5;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.5, end: _scale),
      duration: const Duration(seconds: 4),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular image with border
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 6),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://t3.ftcdn.net/jpg/05/68/99/80/240_F_568998040_m42feFA9RajqmuR5DTlWwox44fxE3MOi.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Curved text around the circle
              ArcText(
                radius: 140,
                text: 'MASJID AND HUFFADH APP',
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                startAngle: -3.14 / 3,
                placement: Placement.outside,
                direction: Direction.clockwise,
              ),
            ],
          ),
        );
      },
    );
  }
}
