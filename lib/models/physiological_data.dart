class PhysiologicalData {
  final DateTime timestamp;

  final double heartRate;

  final double spo2;

  final double temperature;

  final int systolic;

  final int diastolic;

  const PhysiologicalData({
    required this.timestamp,
    required this.heartRate,
    required this.spo2,
    required this.temperature,
    required this.systolic,
    required this.diastolic,
  });

  bool get isValid {
    return heartRate > 0 &&
        spo2 > 0 &&
        temperature > 0 &&
        systolic > 0 &&
        diastolic > 0;
  }

  // Heart Rate status
  String get heartRateStatus {
    if (heartRate < 60 || heartRate > 100) {
      return 'Warning';
    }
    return 'Normal';
  }

  // SpO2 status
  String get spo2Status {
    if (spo2 < 95) {
      return 'Warning';
    }
    return 'Normal';
  }

  // Temperature status
  String get temperatureStatus {
    if (temperature < 36.0 || temperature > 37.5) {
      return 'Warning';
    }
    return 'Normal';
  }

  // Blood Pressure status
  String get bloodPressureStatus {
    if (systolic < 90 || systolic > 140 || diastolic < 60 || diastolic > 90) {
      return 'Warning';
    }
    return 'Normal';
  }
}
