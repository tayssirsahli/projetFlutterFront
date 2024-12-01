import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp70/template/navbar.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Dashboard'),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 50.0,
            ),
            ListTile(
              title: const Text('Cosmetique'),
              onTap: () {
                Navigator.pushNamed(context, '/cosmetiques');
              },
            ),
            ListTile(
              title: const Text('Classification'),
              onTap: () {
                Navigator.pushNamed(context, '/classifications');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Provide the path to your image asset
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content (Text, etc.)
          Center(
            child: SizedBox(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Agne',
                  color: Colors.white, // Text color to make it stand out
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Welcome Back'),
                    TypewriterAnimatedText('Dashboard'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
