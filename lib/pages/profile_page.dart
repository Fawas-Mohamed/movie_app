import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/controller/tab_controller.dart';
import 'package:movieapp/pages/about_page.dart';
import 'package:movieapp/pages/setting_page.dart';
import 'package:movieapp/pages/signin_page.dart';
import 'package:movieapp/services/favorite_service.dart';
import 'package:movieapp/services/watched_service.dart';
import 'package:movieapp/services/watchlist_service.dart';
import 'package:movieapp/widgets/profile_header.dart';
import 'package:movieapp/widgets/profile_menu_tile.dart';
import 'package:movieapp/widgets/profile_stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN0K-TbHTkelyQyrcrb-yk-J2G7KmOp66uow&s",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.black);
              },
            ),
          ),

          /// Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    /// Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Profile",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 242, 255, 57),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Profile Header
                    const ProfileHeader(),

                    const SizedBox(height: 30),

                    /// Stats Cards
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

                    /// Menu Tiles
                    ProfileMenuTile(
                      icon: Icons.favorite,
                      title: "My Favorites",
                      onTap: () {
                        TabControllerNotifier.changeTab(
                          1,
                        ); // switch to Favorite tab
                      },
                    ),

                    ProfileMenuTile(
                      icon: Icons.bookmark,
                      title: "My Watchlist",
                      onTap: () {
                        TabControllerNotifier.changeTab(
                          2,
                        ); // switch to Favorite tab
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

                    /// Logout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
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
        ],
      ),
    );
  }
}
