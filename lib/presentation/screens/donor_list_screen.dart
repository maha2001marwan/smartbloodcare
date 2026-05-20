import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/blood_provider.dart';
import '../widgets/donor_card.dart';

class DonorsListScreen extends StatefulWidget {
  const DonorsListScreen({super.key});

  @override
  State<DonorsListScreen> createState() => _DonorsListScreenState();
}

class _DonorsListScreenState extends State<DonorsListScreen> {
  final _searchController = TextEditingController();
  final List<String> _bloodTypes = const [
    'الكل',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BloodProvider>().fetchDonors());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BloodProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),
      appBar: AppBar(title: const Text('المتبرعون')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              controller: _searchController,
              onChanged: provider.searchDonors,
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم أو المدينة أو الفصيلة',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _bloodTypes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final type = _bloodTypes[index];
                final isSelected = provider.selectedBloodType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  showCheckmark: false,
                  selectedColor: const Color(0xFFE23D4F),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFE23D4F),
                    fontWeight: FontWeight.w800,
                  ),
                  onSelected: (_) => provider.filterDonorsByBloodType(type),
                );
              },
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.donors.isEmpty
                ? const Center(
                    child: Text('لا يوجد متبرعون بهذه الفصيلة حالياً.'),
                  )
                : RefreshIndicator(
                    onRefresh: provider.fetchDonorsFromAPI,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 110),
                      itemCount: provider.donors.length,
                      itemBuilder: (context, index) =>
                          DonorCard(donor: provider.donors[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
