import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          centerTitle: true,
          title: const Text(
            'Your group',
            style: TextStyle(
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
        ),
        body: Center(child: Image.asset('assets/qr-code.png')));
  }
}
