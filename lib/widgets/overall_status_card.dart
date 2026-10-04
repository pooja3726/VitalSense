import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class OverallStatusCard extends StatelessWidget {
  final bool isNormal;
  final String lastUpdated;

  const OverallStatusCard({
    super.key,
    required this.isNormal,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isNormal ? AppTheme.success : Colors.orange;

    final IconData statusIcon = isNormal
        ? Icons.check_circle_rounded
        : Icons.warning_rounded;

    final String statusTitle = isNormal
        ? 'All measurements are stable'
        : 'Attention required';

    final String statusSubtitle = isNormal
        ? 'Current physiological measurements are within the expected range.'
        : 'One or more measurements need attention.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withValues(alpha: 0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monitoring Status',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  statusSubtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Last updated: $lastUpdated',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
