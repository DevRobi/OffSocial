import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/counter.dart';

class MyBottomNavigationBar extends StatelessWidget {
  @override
  const MyBottomNavigationBar({
    Key? key,
    required this.onTapped,
    required this.pageController,
  }) : super(key: key);
  final void Function(int)? onTapped;
  final PageController pageController;

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 30,
      type: BottomNavigationBarType.shifting,
      selectedFontSize: 20,
      selectedIconTheme:
          const IconThemeData(color: Color.fromARGB(218, 52, 51, 51)),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedIconTheme: const IconThemeData(
        color: Colors.deepOrangeAccent,
      ),
      selectedItemColor: const Color.fromARGB(255, 64, 156, 255),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_rounded), label: 'szeklet'),
        BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded), label: 'urulek'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded), label: 'trotty'),
      ],
      onTap: onTapped,
      currentIndex: Provider.of<PageIndexProviderModel>(context).pageNumber,
    );
  }
}
