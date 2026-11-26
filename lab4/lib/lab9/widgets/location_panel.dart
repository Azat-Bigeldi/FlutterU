import 'package:flutter/material.dart';

import '../models/location_fix.dart';
import '../theme.dart';

String formatDateTime(DateTime t) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${t.year}-${two(t.month)}-${two(t.day)} '
      '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// Карточка с координатами или индикатором поиска GPS.
class LocationPanel extends StatelessWidget {
  final LocationFix? fix;
  final bool isLoading;

  /// Время снимка; если не задано, показывается время измерения GPS.
  final DateTime? timestamp;

  const LocationPanel({
    super.key,
    required this.fix,
    this.isLoading = false,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final fix = this.fix;
    final time = timestamp ?? fix?.timestamp;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: isLoading
          ? const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Определяем местоположение…'),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row(
                  Icons.location_on_outlined,
                  'Latitude',
                  fix?.latitude.toStringAsFixed(6),
                ),
                _row(
                  Icons.location_on_outlined,
                  'Longitude',
                  fix?.longitude.toStringAsFixed(6),
                ),
                _row(
                  Icons.terrain_outlined,
                  'Altitude',
                  fix == null ? null : '${fix.altitude.toStringAsFixed(1)} m',
                ),
                _row(
                  Icons.gps_fixed,
                  'Accuracy',
                  fix == null ? null : '± ${fix.accuracy.toStringAsFixed(1)} m',
                ),
                _row(
                  Icons.access_time,
                  'Timestamp',
                  time == null ? null : formatDateTime(time),
                ),
              ],
            ),
    );
  }

  Widget _row(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: FlipColors.blue),
          const SizedBox(width: 8),
          Text('$label: '),
          Expanded(
            child: Text(
              value ?? '—',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
