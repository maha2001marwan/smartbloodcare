import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _dropController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // ننتظر حتى نحصل على أول تحديث لحالة المصادقة من Firebase
    // وفي نفس الوقت ننتظر ثانيتين ونصف على الأقل لضمان عرض الأنيمي
    //شن بشكل جميل
    final authFuture = FirebaseAuth.instance.authStateChanges().first;
    final delayFuture = Future.delayed(const Duration(milliseconds: 2500));
    
    final results = await Future.wait([authFuture, delayFuture]);
    final user = results[0] as User?;

    if (!mounted) return;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      final box = GetStorage();
      bool seenOnboarding = box.read('seenOnboarding') ?? false;
      if (seenOnboarding) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFF7B0000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background circles
            ..._buildBackgroundCircles(),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Blood drop icon with animation
                  _BloodDropIcon(pulseController: _pulseController)
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 32),

                  // شعار متحرك (قلب) باستخدام flutter_animate
                  const Icon(Icons.favorite, color: Colors.white, size: 48)
                      .animate()
                      .scale(duration: 600.ms, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), curve: Curves.elasticOut)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 20),

                  // اسم التطبيق
                  const Text(
                    'SmartCare',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 10),

                  Text(
                    'بنك الدم الذكي',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                ],
              ),
            ),

            // Bottom tagline
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Loading dots
                  _LoadingDots()
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 12),
                  
                  // رسالة ترحيب ديناميكية
                  Text(
                    FirebaseAuth.instance.currentUser != null 
                        ? 'مرحباً بعودتك...' 
                        : 'جاري تجهيز بيئتك...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate(delay: 1000.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 20),

                  Text(
                    'كل قطرة دم... حياة جديدة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      .animate(delay: 1200.ms)
                      .fadeIn(duration: 600.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() => [
    const Positioned(
      top: -80,
      right: -80,
      child: _Circle(size: 260, opacity: 0.08),
    ),
    const Positioned(
      top: 60,
      left: -60,
      child: _Circle(size: 160, opacity: 0.06),
    ),
    const Positioned(
      bottom: -100,
      left: -60,
      child: _Circle(size: 300, opacity: 0.1),
    ),
    const Positioned(
      bottom: 100,
      right: -40,
      child: _Circle(size: 180, opacity: 0.07),
    ),
  ];
}

class _BloodDropIcon extends StatelessWidget {
  final AnimationController pulseController;
  const _BloodDropIcon({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.06);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.bloodtype_rounded,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = (_ctrl.value - delay).clamp(0.0, 1.0);
            final opacity = (0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2)).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
