import 'package:flutter/material.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  static const List<Tip> tips = [
    Tip(
      title: 'اشرب الماء',
      desc: 'حافظ على السوائل قبل وبعد التبرع لتجنب التعب والدوخة.',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF0EA5E9),
    ),
    Tip(
      title: 'تناول وجبة خفيفة',
      desc: 'اختر وجبة تحتوي على الحديد قبل الموعد بعدة ساعات.',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFF97316),
    ),
    Tip(
      title: 'خذ قسطاً من الراحة',
      desc: 'تجنب المجهود البدني الشاق لمدة 24 ساعة بعد التبرع.',
      icon: Icons.hotel_rounded,
      color: Color(0xFF10A37F),
    ),
    Tip(
      title: 'تبرع بأمان',
      desc: 'يمكن للبالغ السليم التبرع دورياً حسب توصية الطبيب.',
      icon: Icons.event_available_rounded,
      color: Color(0xFF8B5CF6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),
      appBar: AppBar(title: const Text('إرشادات التبرع')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE23D4F),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.health_and_safety_rounded,
                  color: Colors.white,
                  size: 42,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'نصائح بسيطة تساعدك على تجربة تبرع صحية وآمنة.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...tips.map((tip) => TipCard(tip: tip)),
        ],
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final Tip tip;

  const TipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF4E1E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tip.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(tip.icon, color: tip.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tip.desc,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Tip {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;

  const Tip({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
  });
}
