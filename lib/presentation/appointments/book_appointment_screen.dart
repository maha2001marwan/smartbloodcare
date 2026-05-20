import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? _date;
  String? _bank;
  String? _time;

  static const _banks = ['بنك دم الملك فهد', 'مركز نقل الدم المركزي'];
  static const _times = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00'];

  @override
  Widget build(BuildContext context) {
    final canSubmit = _date != null && _bank != null && _time != null;
    return Scaffold(
      appBar: AppBar(title: const Text('حجز موعد')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _bank,
            hint: const Text('اختر بنك الدم'),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.water_drop_rounded)),
            items: _banks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: (v) => setState(() => _bank = v),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_rounded),
            label: Text(_date == null ? 'اختر التاريخ' : '${_date!.day}/${_date!.month}/${_date!.year}'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _times.map((t) {
              final selected = _time == t;
              return ChoiceChip(
                label: Text(t),
                selected: selected,
                onSelected: (_) => setState(() => _time = t),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: selected ? Colors.white : AppColors.primary),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: canSubmit
                ? () {
                    Get.back();
                    Get.snackbar('تم', 'تم حجز الموعد بنجاح', backgroundColor: AppColors.success, colorText: Colors.white);
                  }
                : null,
            child: const Text('تأكيد الحجز'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null) setState(() => _date = date);
  }
}
