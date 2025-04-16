import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))],
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/icons/app_icon.png')),
        ),
      ),
      nextScreen: const OnboardingPage(),
      duration: 3000,
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.leftToRight,
      backgroundColor: AppColors.primary,
    );
  }
}
