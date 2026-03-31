import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/controller/tab_controller.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/pages/about_page.dart';
import 'package:movieapp/pages/setting_page.dart';
import 'package:movieapp/pages/signin_page.dart';
import 'package:movieapp/services/favorite_service.dart';
import 'package:movieapp/services/watched_service.dart';
import 'package:movieapp/services/watchlist_service.dart';
import 'package:movieapp/widgets/app_background.dart';
import 'package:movieapp/widgets/app_header.dart';
import 'package:movieapp/widgets/profile_header.dart';
import 'package:movieapp/widgets/profile_menu_tile.dart';
import 'package:movieapp/widgets/profile_stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  AppHeader(title: "Profile"),

                  const SizedBox(height: 10),

                  const ProfileHeader(),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<int>(
                        stream: FavoriteService.favoriteCount(),
                        builder: (context, snapshot) {
                          return ProfileStatCard(
                            icon: Icons.favorite,
                            title: "Favorite",
                            value: snapshot.data?.toString() ?? "0",
                          );
                        },
                      ),
                      StreamBuilder<int>(
                        stream: WatchedService.watchedCount(),
                        builder: (context, snapshot) {
                          return ProfileStatCard(
                            icon: Icons.movie,
                            title: "Watched",
                            value: snapshot.data?.toString() ?? "0",
                          );
                        },
                      ),
                      StreamBuilder<int>(
                        stream: WatchlistService.watchlistCount(),
                        builder: (context, snapshot) {
                          return ProfileStatCard(
                            icon: Icons.bookmark,
                            title: "Watchlist",
                            value: snapshot.data?.toString() ?? "0",
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  ProfileMenuTile(
                    icon: Icons.favorite,
                    title: "My Favorites",
                    onTap: () {
                      TabControllerNotifier.changeTab(1);
                    },
                  ),

                  ProfileMenuTile(
                    icon: Icons.bookmark,
                    title: "My Watchlist",
                    onTap: () {
                      TabControllerNotifier.changeTab(2);
                    },
                  ),

                  ProfileMenuTile(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),

                  ProfileMenuTile(
                    icon: Icons.info,
                    title: "About App",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SigninPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
