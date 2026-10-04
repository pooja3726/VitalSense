import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/physiological_data.dart';
import '../theme/app_theme.dart';

class BloodPressureChart extends StatelessWidget {
  final List<PhysiologicalData> measurements;

  const BloodPressureChart({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return const Center(
        child: Text(
          'No blood pressure data available',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final systolicSpots = measurements.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
    }).toList();

    final diastolicSpots = measurements.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
    }).toList();

    final maxX = systolicSpots.length > 1
        ? (systolicSpots.length - 1).toDouble()
        : 1.0;

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minY: 50,
          maxY: 150,
          minX: 0,
          maxX: maxX,

          // GRID
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.bloodPressure.withValues(alpha: 0.08),
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
                interval: 20,
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
                  final bool isSystolic = spot.barIndex == 0;

                  return LineTooltipItem(
                    isSystolic
                        ? 'SYS  ${spot.y.toStringAsFixed(0)} mmHg'
                        : 'DIA  ${spot.y.toStringAsFixed(0)} mmHg',
                    TextStyle(
                      color: isSystolic
                          ? AppTheme.bloodPressure
                          : AppTheme.spo2,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          // TWO BP LINES
          lineBarsData: [
            // ==============================
            // SYSTOLIC
            // ==============================
            LineChartBarData(
              spots: systolicSpots,

              isCurved: true,
              curveSmoothness: 0.30,

              color: AppTheme.bloodPressure,

              barWidth: 4,
              isStrokeCapRound: true,
              isStrokeJoinRound: true,

              shadow: Shadow(
                color: AppTheme.bloodPressure.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),

              dotData: FlDotData(
                show: systolicSpots.length <= 15,
                getDotPainter: (spot, percent, bar, index) {
                  final bool isLatest = index == systolicSpots.length - 1;

                  return FlDotCirclePainter(
                    radius: isLatest ? 5 : 3,
                    color: Colors.white,
                    strokeWidth: isLatest ? 3 : 2,
                    strokeColor: AppTheme.bloodPressure,
                  );
                },
              ),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.bloodPressure.withValues(alpha: 0.13),
                    AppTheme.bloodPressure.withValues(alpha: 0.04),
                    AppTheme.bloodPressure.withValues(alpha: 0.00),
                  ],
                ),
              ),
            ),

            // ==============================
            // DIASTOLIC
            // ==============================
            LineChartBarData(
              spots: diastolicSpots,

              isCurved: true,
              curveSmoothness: 0.30,

              color: AppTheme.spo2,

              barWidth: 4,
              isStrokeCapRound: true,
              isStrokeJoinRound: true,

              shadow: Shadow(
                color: AppTheme.spo2.withValues(alpha: 0.22),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),

              dotData: FlDotData(
                show: diastolicSpots.length <= 15,
                getDotPainter: (spot, percent, bar, index) {
                  final bool isLatest = index == diastolicSpots.length - 1;

                  return FlDotCirclePainter(
                    radius: isLatest ? 5 : 3,
                    color: Colors.white,
                    strokeWidth: isLatest ? 3 : 2,
                    strokeColor: AppTheme.spo2,
                  );
                },
              ),

              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
