import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/physiological_data.dart';
import '../theme/app_theme.dart';

class Spo2Chart extends StatelessWidget {
  final List<PhysiologicalData> measurements;

  const Spo2Chart({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return const Center(
        child: Text(
          'No SpO₂ data available',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final spots = measurements.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.spo2);
    }).toList();

    final maxX = spots.length > 1 ? (spots.length - 1).toDouble() : 1.0;

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: 90,
          maxY: 100,
          minX: 0,
          maxX: maxX,

          // GRID
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.spo2.withValues(alpha: 0.08),
                strokeWidth: 1,
              );
            },
          ),

          // BORDER
          borderData: FlBorderData(show: false),

          // AXIS
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // TOUCH TOOLTIP
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipColor: (touchedSpot) {
                return AppTheme.textPrimary;
              },
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(0)}% SpO₂',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          // LINE
          lineBarsData: [
            LineChartBarData(
              spots: spots,

              isCurved: true,
              curveSmoothness: 0.30,

              color: AppTheme.spo2,

              barWidth: 4,
              isStrokeCapRound: true,
              isStrokeJoinRound: true,

              // SOFT GLOW
              shadow: Shadow(
                color: AppTheme.spo2.withValues(alpha: 0.28),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),

              // DOTS
              dotData: FlDotData(
                show: spots.length <= 15,
                getDotPainter: (spot, percent, bar, index) {
                  final bool isLatest = index == spots.length - 1;

                  return FlDotCirclePainter(
                    radius: isLatest ? 5 : 3,
                    color: Colors.white,
                    strokeWidth: isLatest ? 3 : 2,
                    strokeColor: AppTheme.spo2,
                  );
                },
              ),

              // BLUE GRADIENT
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.spo2.withValues(alpha: 0.20),
                    AppTheme.spo2.withValues(alpha: 0.07),
                    AppTheme.spo2.withValues(alpha: 0.01),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
