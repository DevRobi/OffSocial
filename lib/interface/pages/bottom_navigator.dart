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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 30,
      type: BottomNavigationBarType.shifting,
      selectedFontSize: 20,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedIconTheme: const IconThemeData(color: Colors.black),
      selectedIconTheme: const IconThemeData(color: Colors.green),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined), label: 'Statistics'),
        BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded), label: 'Leaderboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded), label: 'Friends'),
      ],
      onTap: onTapped,
      currentIndex: Provider.of<PageIndexProviderModel>(context).pageNumber,
    );
  }
}
