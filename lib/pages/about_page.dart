import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/widgets/app_background.dart';
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
                            color:AppColors.primary,
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
                            "About Us",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

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
                              infoRow("Version", "1.0.1"),
                              const SizedBox(height: 10),
                              infoRow("Developer", "Mohamed Fawas"),
                              const SizedBox(height: 10),
                              infoRow("Platform", "Flutter"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        sectionTitle("Links"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialButton(
                              Icons.code,
                              "GitHub",
                              () => openUrl("https://github.com/Fawas-Mohamed"),
                            ),
                            const SizedBox(width: 12),
                            socialButton(
                              Icons.language,
                              "Website",
                              () => openUrl("https://popcornpal.com"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        sectionTitle("Follow Us"),

                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            socialButton(Icons.camera_alt, "Instagram", () {
                              openUrl("https://instagram.com/popcornpal");
                            }),
                            socialButton(Icons.facebook, "Facebook", () {
                              openUrl("https://facebook.com/popcornpal");
                            }),
                            socialButton(Icons.music_note, "TikTok", () {
                              openUrl("https://tiktok.com/@popcornpal");
                            }),
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

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget socialButton(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.secondary, size: 18),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: AppColors.secondary)),
          ],
        ),
      ),
    );
  }
}
