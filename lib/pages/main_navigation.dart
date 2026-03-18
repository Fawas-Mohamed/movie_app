import 'package:flutter/material.dart';
import 'package:movieapp/controller/tab_controller.dart';
import 'package:movieapp/pages/home_page.dart';
import 'package:movieapp/pages/favorite_page.dart';
import 'package:movieapp/pages/profile_page.dart';
import 'package:movieapp/pages/watchlist-page.dart';
import 'package:movieapp/widgets/bottom-navigation.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  final List<Widget> pages = const [
    HomePage(),
    FavoritePage(),
    Watchlistpage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: TabControllerNotifier.currentIndex,
      builder: (context, currentIndex, _) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: pages,
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: currentIndex,
            onTap: (index) => TabControllerNotifier.changeTab(index),
          ),
        );
      },
    );
  }
}