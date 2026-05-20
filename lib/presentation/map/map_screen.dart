import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _filter = 'all';
  final MapController _mapController = MapController();

  // Mock markers
  final List<Marker> _markers = [
    const Marker(
      point: LatLng(24.7136, 46.6753), // Riyadh
      width: 40,
      height: 40,
      child: Icon(Icons.water_drop_rounded, color: AppColors.primary, size: 30),
    ),
    const Marker(
      point: LatLng(24.7236, 46.6853),
      width: 40,
      height: 40,
      child: Icon(Icons.local_hospital_rounded, color: AppColors.info, size: 30),
    ),
    const Marker(
      point: LatLng(24.7036, 46.6653),
      width: 40,
      height: 40,
      child: Icon(Icons.person_pin_circle_rounded, color: AppColors.success, size: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('map'.tr)),
      body: Stack(
        children: [
          // ── FREE MAP (OpenStreetMap) ──────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(24.7136, 46.6753),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: isDark 
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.scan_fill_form',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          // ── Top Filter Chips ──────────────────────────────────
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _FilterChips(
              current: _filter,
              onChanged: (v) => setState(() => _filter = v),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3, end: 0),
          ),

          // ── Bottom Info Panel ─────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _MapBottomPanel(filter: _filter)
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.3, end: 0),
          ),

          // ── My Location FAB ───────────────────────────────────
          Positioned(
            bottom: 220,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () {
                _mapController.move(const LatLng(24.7136, 46.6753), 15.0);
              },
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 4,
              child: const Icon(Icons.my_location_rounded),
            ).animate(delay: 400.ms).scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              curve: Curves.elasticOut,
              duration: 600.ms,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _FilterChips({required this.current, required this.onChanged});

  static const _items = [
    ('all', 'الكل', Icons.layers_rounded),
    ('banks', 'بنوك الدم', Icons.water_drop_rounded),
    ('hospitals', 'مستشفيات', Icons.local_hospital_rounded),
    ('donors', 'متبرعون', Icons.person_pin_circle_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _items.map((item) {
          final selected = current == item.$1;
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: FilterChip(
              avatar: Icon(
                item.$3,
                size: 16,
                color: selected ? Colors.white : AppColors.primary,
              ),
              label: Text(
                item.$2,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              selected: selected,
              onSelected: (_) => onChanged(item.$1),
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MapBottomPanel extends StatelessWidget {
  final String filter;
  const _MapBottomPanel({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                ..._buildItems(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (filter) {
      case 'banks': return 'بنوك الدم القريبة';
      case 'hospitals': return 'المستشفيات القريبة';
      case 'donors': return 'المتبرعون القريبون';
      default: return 'القريبون منك';
    }
  }

  List<Widget> _buildItems(BuildContext context) {
    final items = [
      const _NearbyItem(
        icon: Icons.water_drop_rounded,
        color: AppColors.primary,
        name: 'بنك دم الملك فهد',
        distance: '2.4 كم',
      ),
      const _NearbyItem(
        icon: Icons.local_hospital_rounded,
        color: AppColors.info,
        name: 'مستشفى الملك فهد',
        distance: '2.4 كم',
      ),
    ];
    return items.map((item) => _NearbyItemWidget(item: item)).toList();
  }
}

class _NearbyItem {
  final IconData icon;
  final Color color;
  final String name;
  final String distance;
  const _NearbyItem({
    required this.icon,
    required this.color,
    required this.name,
    required this.distance,
  });
}

class _NearbyItemWidget extends StatelessWidget {
  final _NearbyItem item;
  const _NearbyItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.distance,
              style: TextStyle(
                color: item.color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
