import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/user.dart';

class DigitalDonorCard extends StatelessWidget {
  final User user;
  
  const DigitalDonorCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFE23D4F), Color(0xFF9F1239)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE23D4F).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background Decorative Circles
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // QR Code & Status
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data: 'USER_ID:${user.id}',
                          version: QrVersions.auto,
                          size: 100.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'متبرع معتمد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'بطاقة متبرع ذكية',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _InfoLabel(label: 'الفصيلة', value: user.bloodType),
                            const SizedBox(width: 24),
                            _InfoLabel(label: 'المدينة', value: user.city),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.verified_user_rounded, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'رقم العضوية: SC-${user.id.substring(0, 4).toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Decorative Blood Drop Icon
            Positioned(
              bottom: -20,
              right: -10,
              child: Opacity(
                opacity: 0.1,
                child: Transform.rotate(
                  angle: -0.2,
                  child: const Icon(Icons.bloodtype, size: 120, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.1)).slideX(begin: 0.2, end: 0).fadeIn();
  }
}

class _InfoLabel extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
