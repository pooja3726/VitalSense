import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String status;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
  });

  Color get metricColor {
    switch (title) {
      case 'Heart Rate':
        return AppTheme.heartRate;
      case 'SpO₂':
        return AppTheme.spo2;
      case 'Temperature':
        return AppTheme.temperature;
      case 'Blood Pressure':
        return AppTheme.bloodPressure;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNormal = status == 'Normal';

    final Color statusColor = isNormal ? AppTheme.success : AppTheme.warning;

    final Color statusBackground = isNormal
        ? AppTheme.success.withValues(alpha: 0.09)
        : AppTheme.warning.withValues(alpha: 0.10);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: metricColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: metricColor.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: metricColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: metricColor, size: 25),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF53666D),
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: metricColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 0.95,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          unit,
                          style: const TextStyle(
                            color: Color(0xFF819196),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isNormal
                              ? Icons.check_circle_rounded
                              : Icons.warning_rounded,
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: metricColor.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}
