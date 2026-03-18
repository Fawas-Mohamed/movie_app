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
          backgroundColor: Colors.black, // ✅ IMPORTANT
          body: Stack(
            children: [
              /// Pages
              Positioned.fill(
                child: IndexedStack(index: currentIndex, children: pages),
              ),

              /// Bottom Navigation INSIDE body (fixes shadow)
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
