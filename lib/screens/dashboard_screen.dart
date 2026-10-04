import 'dart:async';

import 'package:flutter/material.dart';

import '../models/physiological_data.dart';
import '../services/mock_data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_pressure_chart.dart';
import '../widgets/heart_rate_chart.dart';
import '../widgets/metric_card.dart';
import '../widgets/spo2_chart.dart';
import '../widgets/temperature_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<PhysiologicalData> measurements;
  Timer? _updateTimer;

  String selectedRange = '1H';
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    measurements = MockDataService.getHistoricalData();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => isLoading = false);
    });

    _startLiveUpdates();
  }

  void _startLiveUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      try {
        final newMeasurement = MockDataService.generateLatestMeasurement();

        final isValid = MockDataService.validateData([newMeasurement]);

        if (!isValid || !mounted) return;

        setState(() {
          errorMessage = null;
          measurements.add(newMeasurement);

          if (measurements.length > 50) {
            measurements.removeAt(0);
          }
        });
      } catch (error) {
        if (!mounted) return;

        setState(() {
          errorMessage = 'Unable to update physiological data.';
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  PhysiologicalData? get latestMeasurement {
    if (measurements.isEmpty) return null;
    return measurements.last;
  }

  List<PhysiologicalData> get filteredMeasurements {
    final now = DateTime.now();
    Duration duration;

    switch (selectedRange) {
      case '6H':
        duration = const Duration(hours: 6);
        break;
      case '24H':
        duration = const Duration(hours: 24);
        break;
      case '1H':
      default:
        duration = const Duration(hours: 1);
        break;
    }

    final startTime = now.subtract(duration);

    return measurements.where((m) => m.timestamp.isAfter(startTime)).toList();
  }

  bool get hasData => filteredMeasurements.isNotEmpty;

  bool get isOverallStatusNormal {
    final latest = latestMeasurement;

    if (latest == null) return false;

    return latest.heartRateStatus == 'Normal' &&
        latest.spo2Status == 'Normal' &&
        latest.temperatureStatus == 'Normal' &&
        latest.bloodPressureStatus == 'Normal';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: _PremiumLoading());
    }

    if (errorMessage != null) {
      return _buildErrorScreen();
    }

    final latest = latestMeasurement;

    if (latest == null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F8),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7FBFB), Color(0xFFF2F7F8), Color(0xFFEEF5F6)],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLiveBadge(),
                const SizedBox(height: 18),

                _buildStatusCard(latest),
                const SizedBox(height: 30),

                _buildSectionHeader(
                  title: 'Current Measurements',
                  subtitle: 'Latest physiological readings',
                  icon: Icons.monitor_heart_rounded,
                ),
                const SizedBox(height: 14),

                _buildMetricGrid(latest),
                const SizedBox(height: 34),

                _buildSectionHeader(
                  title: 'Health Trends',
                  subtitle: 'Monitor your physiological data over time',
                  icon: Icons.insights_rounded,
                ),
                const SizedBox(height: 14),

                _buildChartCard(
                  title: 'Heart Rate Trend',
                  subtitle: 'Heart rate changes over time',
                  icon: Icons.favorite_rounded,
                  color: AppTheme.heartRate,
                  chart: hasData
                      ? HeartRateChart(measurements: filteredMeasurements)
                      : _emptyChartMessage(
                          'No heart rate data available for this range.',
                        ),
                  showTimeRange: true,
                ),

                const SizedBox(height: 20),

                _buildChartCard(
                  title: 'SpO₂ Trend',
                  subtitle: 'Blood oxygen level over time',
                  icon: Icons.air_rounded,
                  color: AppTheme.spo2,
                  chart: hasData
                      ? Spo2Chart(measurements: filteredMeasurements)
                      : _emptyChartMessage(
                          'No SpO₂ data available for this range.',
                        ),
                ),

                const SizedBox(height: 20),

                _buildChartCard(
                  title: 'Temperature Trend',
                  subtitle: 'Body temperature over time',
                  icon: Icons.thermostat_rounded,
                  color: AppTheme.temperature,
                  chart: hasData
                      ? TemperatureChart(measurements: filteredMeasurements)
                      : _emptyChartMessage(
                          'No temperature data available for this range.',
                        ),
                ),

                const SizedBox(height: 20),

                _buildChartCard(
                  title: 'Blood Pressure Trend',
                  subtitle: 'Systolic and diastolic pressure over time',
                  icon: Icons.monitor_heart_rounded,
                  color: AppTheme.bloodPressure,
                  chart: hasData
                      ? BloodPressureChart(measurements: filteredMeasurements)
                      : _emptyChartMessage(
                          'No blood pressure data available for this range.',
                        ),
                ),

                const SizedBox(height: 24),

                _buildLatestUpdate(latest),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 82,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.22),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VitalSense',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF142329),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Physiological Monitoring',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF71838A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF9F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBCEBD3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 8, color: AppTheme.success),
              SizedBox(width: 7),
              Text(
                'LIVE',
                style: TextStyle(
                  color: Color(0xFF158A52),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.18)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: AppTheme.primary),
          SizedBox(width: 8),
          Text(
            'Live Monitoring',
            style: TextStyle(
              color: Color(0xFF087A6D),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(width: 7),
          Icon(Icons.wifi_rounded, size: 15, color: AppTheme.primary),
        ],
      ),
    );
  }

  Widget _buildStatusCard(PhysiologicalData latest) {
    final isNormal = isOverallStatusNormal;

    final Color accent = isNormal ? AppTheme.success : AppTheme.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isNormal
              ? const [Color(0xFFFFFFFF), Color(0xFFF1FBF7)]
              : const [Color(0xFFFFFFFF), Color(0xFFFFF8ED)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNormal ? Icons.check_rounded : Icons.warning_rounded,
              color: accent,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MONITORING STATUS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF71838A),
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isNormal
                      ? 'All measurements are stable'
                      : 'Attention required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isNormal
                      ? 'Current physiological measurements are within the expected range.'
                      : 'One or more measurements may be outside the expected range.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF61747A),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: accent),
                    const SizedBox(width: 5),
                    Text(
                      'Last updated: ${_formatTime(latest.timestamp)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF71838A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              isNormal ? 'STABLE' : 'CHECK',
              style: TextStyle(
                color: accent,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 19, color: AppTheme.primary),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF142329),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF71838A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricGrid(PhysiologicalData latest) {
    final cards = [
      MetricCard(
        icon: Icons.favorite_rounded,
        title: 'Heart Rate',
        value: latest.heartRate.toStringAsFixed(0),
        unit: 'BPM',
        status: latest.heartRateStatus,
      ),
      MetricCard(
        icon: Icons.air_rounded,
        title: 'SpO₂',
        value: latest.spo2.toStringAsFixed(0),
        unit: '%',
        status: latest.spo2Status,
      ),
      MetricCard(
        icon: Icons.thermostat_rounded,
        title: 'Temperature',
        value: latest.temperature.toStringAsFixed(1),
        unit: '°C',
        status: latest.temperatureStatus,
      ),
      MetricCard(
        icon: Icons.monitor_heart_rounded,
        title: 'Blood Pressure',
        value: '${latest.systolic}/${latest.diastolic}',
        unit: 'mmHg',
        status: latest.bloodPressureStatus,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.65,
            ),
            itemBuilder: (context, index) => cards[index],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 14),
            cards[1],
            const SizedBox(height: 14),
            cards[2],
            const SizedBox(height: 14),
            cards[3],
          ],
        );
      },
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget chart,
    bool showTimeRange = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2EAEC)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 23),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF17252B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF71838A),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: color,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(6, 10, 6, 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFCFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8EFF0)),
              ),
              child: chart,
            ),
            if (showTimeRange) ...[
              const SizedBox(height: 14),
              _buildTimeRangeSelector(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F8),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE0E9EB)),
      ),
      child: Row(
        children: [
          _TimeRangeButton(
            label: '1H',
            selected: selectedRange == '1H',
            onTap: () => setState(() => selectedRange = '1H'),
          ),
          _TimeRangeButton(
            label: '6H',
            selected: selectedRange == '6H',
            onTap: () => setState(() => selectedRange = '6H'),
          ),
          _TimeRangeButton(
            label: '24H',
            selected: selectedRange == '24H',
            onTap: () => setState(() => selectedRange = '24H'),
          ),
        ],
      ),
    );
  }

  Widget _emptyChartMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            size: 30,
            color: Color(0xFF8A9A9F),
          ),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF71838A)),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestUpdate(PhysiologicalData latest) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.sync_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest Measurement',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF17252B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Updated at ${_formatTime(latest.timestamp)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF61747A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Data updates automatically every 5 seconds.',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF8A9A9F)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'VitalSense',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
            color: Color(0xFF17252B),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppTheme.danger.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppTheme.danger,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Data Update Error',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17252B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF61747A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => errorMessage = null);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
        ? 12
        : time.hour;

    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

class _TimeRangeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimeRangeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.20),
                      blurRadius: 9,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
              color: selected ? Colors.white : const Color(0xFF61747A),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumLoading extends StatelessWidget {
  const _PremiumLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5FAFA), Color(0xFFEAF5F3)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.22),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'VitalSense',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF17252B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Preparing physiological monitoring...',
              style: TextStyle(fontSize: 12, color: Color(0xFF71838A)),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
