import 'package:flutter/material.dart';

import '../../data/models/donor.dart';

class DonorCard extends StatelessWidget {
  final Donor donor;
  final VoidCallback? onCallPressed;

  const DonorCard({super.key, required this.donor, this.onCallPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFF4E1E1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFFFE4E6),
              backgroundImage: donor.imageUrl.isEmpty
                  ? null
                  : NetworkImage(donor.imageUrl),
              child: donor.imageUrl.isEmpty
                  ? const Icon(Icons.person_rounded, color: Color(0xFFE23D4F))
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Tag(
                        icon: Icons.bloodtype_rounded,
                        text: donor.bloodType,
                      ),
                      _Tag(icon: Icons.location_on_rounded, text: donor.city),
                      _Tag(
                        icon: Icons.event_available_rounded,
                        text: donor.lastDonation,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'اتصال',
              onPressed: onCallPressed ?? () => _showCallDialog(context),
              icon: const Icon(Icons.phone_rounded, color: Color(0xFF10A37F)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('الاتصال بالمتبرع'),
          content: Text('هل تريد الاتصال بـ ${donor.name}؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('اتصال'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFE23D4F)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
