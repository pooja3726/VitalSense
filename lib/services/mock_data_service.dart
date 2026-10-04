import '../models/physiological_data.dart';

class MockDataService {
  static List<PhysiologicalData> getHistoricalData() {
    final now = DateTime.now();

    return [
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 55)),
        heartRate: 76,
        spo2: 98,
        temperature: 36.6,
        systolic: 117,
        diastolic: 75,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 50)),
        heartRate: 78,
        spo2: 98,
        temperature: 36.7,
        systolic: 118,
        diastolic: 76,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 45)),
        heartRate: 80,
        spo2: 97,
        temperature: 36.7,
        systolic: 119,
        diastolic: 77,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 40)),
        heartRate: 79,
        spo2: 98,
        temperature: 36.8,
        systolic: 120,
        diastolic: 78,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 35)),
        heartRate: 82,
        spo2: 97,
        temperature: 36.8,
        systolic: 121,
        diastolic: 79,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 30)),
        heartRate: 81,
        spo2: 98,
        temperature: 36.7,
        systolic: 119,
        diastolic: 77,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 25)),
        heartRate: 77,
        spo2: 99,
        temperature: 36.6,
        systolic: 118,
        diastolic: 76,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 20)),
        heartRate: 75,
        spo2: 98,
        temperature: 36.6,
        systolic: 116,
        diastolic: 74,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 15)),
        heartRate: 78,
        spo2: 98,
        temperature: 36.7,
        systolic: 118,
        diastolic: 76,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 10)),
        heartRate: 80,
        spo2: 97,
        temperature: 36.8,
        systolic: 120,
        diastolic: 78,
      ),
      PhysiologicalData(
        timestamp: now.subtract(const Duration(minutes: 5)),
        heartRate: 79,
        spo2: 98,
        temperature: 36.7,
        systolic: 119,
        diastolic: 77,
      ),
      PhysiologicalData(
        timestamp: now,
        heartRate: 78,
        spo2: 98,
        temperature: 36.7,
        systolic: 118,
        diastolic: 76,
      ),
    ];
  }

  static bool validateData(List<PhysiologicalData> data) {
    if (data.isEmpty) {
      return false;
    }

    for (final measurement in data) {
      if (!measurement.isValid) {
        return false;
      }

      if (measurement.heartRate.isNaN ||
          measurement.spo2.isNaN ||
          measurement.temperature.isNaN) {
        return false;
      }

      if (measurement.systolic <= 0 || measurement.diastolic <= 0) {
        return false;
      }
    }

    return true;
  }

  static PhysiologicalData generateLatestMeasurement() {
    final now = DateTime.now();

    final seconds = now.second;

    final heartRate = 75 + (seconds % 10);

    final spo2 = 97 + (seconds % 3);

    final temperature = 36.5 + ((seconds % 5) * 0.1);

    final systolic = 116 + (seconds % 5);

    final diastolic = 74 + (seconds % 4);

    return PhysiologicalData(
      timestamp: now,
      heartRate: heartRate.toDouble(),
      spo2: spo2.toDouble(),
      temperature: double.parse(temperature.toStringAsFixed(1)),
      systolic: systolic,
      diastolic: diastolic,
    );
  }
}
