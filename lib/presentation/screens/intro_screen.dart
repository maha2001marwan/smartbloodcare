import 'package:flutter/material.dart';
import 'package:smartbloodcare/presentation/widgets/button_sec.dart';
import 'package:smartbloodcare/routes.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7F7),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _HeroPanel(
                          height: constraints.maxHeight < 700 ? 310 : 390,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'SmartCare',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF24181A),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'منصة ذكية تربط المحتاجين للدم بالمتبرعين القريبين بسرعة وأمان.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            height: 1.55,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 22),
                        const Row(
                          children: [
                            Expanded(
                              child: _InfoPill(
                                icon: Icons.speed_rounded,
                                label: 'وصول سريع',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _InfoPill(
                                icon: Icons.verified_user_rounded,
                                label: 'بيانات منظمة',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _InfoPill(
                                icon: Icons.favorite_rounded,
                                label: 'أثر حقيقي',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        ModernButton(
                          text: 'ابدأ الآن',
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.login),
                          backgroundColor: const Color(0xFFE23D4F),
                          height: 58,
                          borderRadius: 18,
                          leadingIcon: Icons.arrow_back_rounded,
                          elevation: 0,
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.register),
                          child: const Text('إنشاء حساب جديد'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final double height;

  const _HeroPanel({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          colors: [Color(0xFFE23D4F), Color(0xFF9F1239)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE23D4F).withValues(alpha: 0.28),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const PositionedDirectional(
            top: -36,
            start: -16,
            child: _SoftCircle(size: 128, opacity: 0.12),
          ),
          const PositionedDirectional(
            bottom: -52,
            end: -28,
            child: _SoftCircle(size: 188, opacity: 0.1),
          ),
          Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 900),
              tween: Tween(begin: 0.82, end: 1),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 138,
                    height: 138,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: const Icon(
                      Icons.bloodtype_rounded,
                      color: Color(0xFFE23D4F),
                      size: 78,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'تبرعك ينقذ حياة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'بنك دم أقرب، أسرع، وأكثر أماناً',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _SoftCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4E1E1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFE23D4F)),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
