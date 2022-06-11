import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:provider/provider.dart';
import 'pages/bottom_navigator.dart';
import 'pages/leaderboard/leaderboardpage.dart';
import 'pages/friends/friendspage.dart';
import 'pages/statistics/statisticspage.dart';
import '../../model/counter.dart';

class PageViewDemo extends StatelessWidget {
  PageViewDemo({Key? key}) : super(key: key) {
    initPlatformState();
  }
  void initPlatformState() async {
    UsageStats.grantUsagePermission();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 1);
    void _onTappedBar(int value) {
      Provider.of<PageIndexProviderModel>(context, listen: false)
          .setPage(value);
      _pageController.animateToPage(value,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }

    void _onPageChanged(int page) {
      Provider.of<PageIndexProviderModel>(context, listen: false).setPage(page);
    }

    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
          pageController: _pageController, onTapped: _onTappedBar),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [StatisticsPage(), LeaderboardPage(), FriendsPage()],
      ),
    );
  }
}
