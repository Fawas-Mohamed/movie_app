import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/widgets/app_background.dart';
import 'package:movieapp/widgets/app_header.dart';
import 'package:movieapp/widgets/back_button.dart';
import 'package:movieapp/widgets/info_row.dart';
import 'package:movieapp/widgets/section_title.dart';
import 'package:movieapp/widgets/social_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void shareApp() {
    Share.share(
      "🎬 Check out PopcornPal!\nYour personal movie companion 🍿\nDownload now!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                AppHeader(leftWidget: AppBackButton(), title: "About Us"),

                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        Image.asset("assets/app_icon.png", height: 100),

                        const SizedBox(height: 15),

                        const Text(
                          "PopcornPal",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Your Personal Movie Companion",
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            children: [
                              InfoRow(title: "Version", value: "1.0.1"),
                              const SizedBox(height: 10),
                              InfoRow(
                                title: "Developer",
                                value: "Mohamed Fawas",
                              ),
                              const SizedBox(height: 10),
                              InfoRow(title: "Platform", value: "Flutter"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        SectionTitle(title: "Links"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialButton(
                              icon: Icons.code,
                              text: "GitHub",
                              onTap: () =>
                                  openUrl("https://github.com/Fawas-Mohamed"),
                            ),
                            const SizedBox(width: 12),
                            SocialButton(
                              icon: Icons.language,
                              text: "Website",
                              onTap: () => openUrl("https://popcornpal.com"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        SectionTitle(title: "Follow Us"),

                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            SocialButton(
                              icon: Icons.camera_alt,
                              text: "Instagram",
                              onTap: () {
                                openUrl("https://instagram.com/popcornpal");
                              },
                            ),
                            SocialButton(
                              icon: Icons.facebook,
                              text: "Facebook",
                              onTap: () {
                                openUrl("https://facebook.com/popcornpal");
                              },
                            ),
                            SocialButton(
                              icon: Icons.music_note,
                              text: "TikTok",
                              onTap: () {
                                openUrl("https://tiktok.com/@popcornpal");
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: shareApp,
                          icon: const Icon(Icons.share),
                          label: const Text("Share App"),
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () =>
                              openUrl("https://popcornpal.com/privacy"),
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Colors.white60,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
