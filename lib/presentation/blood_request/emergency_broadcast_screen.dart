import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class EmergencyBroadcastScreen extends StatefulWidget {
  const EmergencyBroadcastScreen({super.key});

  @override
  State<EmergencyBroadcastScreen> createState() => _EmergencyBroadcastScreenState();
}

class _EmergencyBroadcastScreenState extends State<EmergencyBroadcastScreen> {
  bool _isBroadcasting = false;

  void _startBroadcast() {
    setState(() => _isBroadcasting = true);
    
    // Simulate broadcasting process
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _isBroadcasting = false);
        Get.back();
        Get.snackbar(
          'تم الإرسال بنجاح',
          'تم إرسال نداء استغاثة لجميع المتبرعين في منطقتك',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark premium background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            // Centered pulse + button area
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isBroadcasting) ...[
                      _buildPulseCircle(400, 0.1),
                      _buildPulseCircle(300, 0.2),
                      _buildPulseCircle(200, 0.3),
                    ],

                    GestureDetector(
                      onTap: _isBroadcasting ? null : _startBroadcast,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _isBroadcasting
                              ? [Colors.red.shade400, Colors.red.shade900]
                              : [const Color(0xFFE23D4F), const Color(0xFF9F1239)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 50),
                            const SizedBox(height: 10),
                            Text(
                              _isBroadcasting ? 'جاري الإرسال...' : 'بث استغاثة',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1000.ms),
                  ],
                ),
              ),
            ),

            // Title
            Text(
              _isBroadcasting ? 'جاري تحديد المتبرعين المناسبين...' : 'نداء استغاثة عاجل',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

            const SizedBox(height: 16),

            // Description
            Text(
              _isBroadcasting
                ? 'سيتم إرسال إشعار فوري لـ 150 متبرع مسجل بالقرب منك'
                : 'عند الضغط على الزر، سيتم إرسال تنبيه "نبض" لجميع المتبرعين الذين يحملون فصيلة الدم المطلوبة في منطقتك الجغرافية.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            if (!_isBroadcasting)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber, size: 24),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'هذه الميزة مخصصة للحالات الحرجة فقط. سوء الاستخدام قد يؤدي لتعليق الحساب.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red.withValues(alpha: opacity), width: 2),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 2000.ms)
     .fadeOut(duration: 2000.ms);
  }
}
