import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/widgets/app_background.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.white70))
            : null,
        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
        onTap: onTap,
      ),
    );
  }

  void showInfoDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> showClearHistoryDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          "Clear Search History",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "This feature can be connected later when you save search history.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.background,
                          size: 20,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user?.email?.substring(0, 1).toUpperCase() ?? "U",
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      buildTile(
                        icon: Icons.dark_mode,
                        title: "Theme",
                        subtitle: "Dark mode is enabled for PopcornPals",
                        onTap: () {
                          showInfoDialog(
                            context,
                            title: "Theme",
                            content:
                                "Your app currently uses a dark movie-style theme. Light mode can be added later.",
                          );
                        },
                      ),
                      buildTile(
                        icon: Icons.info_outline,
                        title: "About App",
                        subtitle: "Learn more about PopcornPals",
                        onTap: () {
                          showInfoDialog(
                            context,
                            title: "About PopcornPals",
                            content:
                                "PopcornPals is a movie discovery app built using Flutter, Firebase, and TMDB API. You can explore movies, save favorites, manage your watchlist, and watch trailers.",
                          );
                        },
                      ),
                      buildTile(
                        icon: Icons.verified_outlined,
                        title: "App Version",
                        subtitle: "Version 1.0.0",
                        onTap: () {
                          showInfoDialog(
                            context,
                            title: "App Version",
                            content: "PopcornPals version 1.0.0",
                          );
                        },
                      ),
                      buildTile(
                        icon: Icons.person_outline,
                        title: "Developer Info",
                        subtitle: "Project creator details",
                        onTap: () {
                          showInfoDialog(
                            context,
                            title: "Developer Info",
                            content:
                                "Developed by Fawas.\nBuilt as a modern Flutter movie app project using Firebase authentication and TMDB integration.",
                          );
                        },
                      ),
                      buildTile(
                        icon: Icons.history,
                        title: "Clear Search History",
                        subtitle: "Placeholder for future feature",
                        onTap: () {
                          showClearHistoryDialog(context);
                        },
                      ),
                      buildTile(
                        icon: Icons.logout,
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        title: "Logout",
                        subtitle: "Sign out from your account",
                        trailing: const Icon(Icons.logout, color: Colors.red),
                        onTap: () {
                          showLogoutDialog(context);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
