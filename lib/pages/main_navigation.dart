import 'package:flutter/material.dart';
import 'package:movieapp/controller/tab_controller.dart';
import 'package:movieapp/core/constants.dart';
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
    WatchlistPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: TabControllerNotifier.currentIndex,
      builder: (context, currentIndex, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(index: currentIndex, children: pages),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AppBottomNav(
                  currentIndex: currentIndex,
                  onTap: (index) => TabControllerNotifier.changeTab(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
