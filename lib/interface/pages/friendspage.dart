import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Your Friends. Beat them!',
            style: TextStyle(
              color: Color.fromARGB(255, 61, 61, 213),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 23, 23, 24),
        ),
        body: Center(child: Image.asset('assets/qr-code.png')));
  }
}
