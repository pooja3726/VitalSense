# VitalSense

VitalSense is a Flutter-based mobile prototype for real-time visualization of synthetic physiological time-series data.

The application presents changing physiological measurements through a clear mobile dashboard with reusable metric cards, time-series charts, validation, loading/error handling, and selectable time ranges.

## Project Objective

The objective of VitalSense is to demonstrate a production-oriented mobile experience for displaying physiological measurements clearly and consistently.

The prototype uses synthetic data and does not connect to real medical hardware or confidential external systems.

## Features
- Real-time simulated physiological measurements
- Heart Rate monitoring
- SpO₂ monitoring
- Body Temperature monitoring
- Blood Pressure monitoring
- Overall monitoring status
- Normal and Warning status indicators
- Heart Rate time-series chart
- SpO₂ time-series chart
- Temperature time-series chart
- Blood Pressure time-series chart
- 1H, 6H and 24H time-range selection
- Loading state
- Empty-data handling
- Invalid-data validation
- Error handling
- Responsive mobile layout
- Automatic measurement updates every 5 seconds
- Reusable Flutter widgets

## Technology Stack

- Flutter
- Dart
- Material 3
- fl_chart
- Synthetic/mock data
- Flutter widget testing


## Project Structure

lib/
├── models/
│   └── physiological_data.dart
│
├── screens/
│   └── dashboard_screen.dart
│
├── services/
│   └── mock_data_service.dart
│
├── theme/
│   └── app_theme.dart
│
├── widgets/
│   ├── metric_card.dart
│   ├── overall_status_card.dart
│   ├── heart_rate_chart.dart
│   ├── spo2_chart.dart
│   ├── temperature_chart.dart
│   └── blood_pressure_chart.dart
│
└── main.dart

test/
└── widget_test.dart

## Architecture

VitalSense follows a simple layered structure to separate the user interface, reusable components, data representation, data generation and application styling.

### Architecture Diagram

                    VITALSENSE
                         |
                         v
              +---------------------+
              |   Dashboard Screen  |
              |   Presentation UI   |
              +----------+----------+
                         |
                         v
              +---------------------+
              |  Reusable Widgets   |
              |                     |
              | Metric Cards        |
              | Status Card         |
              | Time-Series Charts  |
              +----------+----------+
                         |
                         v
              +---------------------+
              | Physiological Data  |
              |       Model         |
              +----------+----------+
                         |
                         v
              +---------------------+
              |  Mock Data Service  |
              |                     |
              | Historical Data     |
              | Live Generator      |
              | Validation          |
              +---------------------+

              App Theme
                  |
                  v
          UI Styling & Theme
                                    
## Architecture Components
1. Application Entry Point

main.dart is the application entry point. It initializes the Flutter application, applies the application theme and loads the dashboard screen.

2. Presentation Layer

dashboard_screen.dart contains the main dashboard experience. It manages the displayed measurements, live update cycle, selected time range and different UI states.

3. Reusable UI Components

The widgets directory contains reusable components for metric cards, monitoring status and time-series charts.
This separation keeps the dashboard organized and allows individual UI components to be maintained independently.

4. Data Model Layer

physiological_data.dart defines the structure of a physiological measurement.

Each measurement contains:
  - Timestamp
  - Heart rate
  - SpO₂
  - Temperature
  - Systolic blood pressure
  - Diastolic blood pressure

The model also provides validation and prototype status evaluation for the measurements.

5. Service Layer
mock_data_service.dart provides synthetic physiological measurements for the prototype.

The service provides:
  - Historical measurements
  - Newly generated measurements
  - Data validation

The generated data allows the application to demonstrate changing time-series measurements without requiring real hardware or an external production API.

6. Theme Layer

app_theme.dart contains shared application styling such as colors, typography, card styling and Material 3 theme configuration.

## Technology Rationale

### Flutter

Flutter was selected to build the mobile prototype because it provides a widget-based approach for creating responsive user interfaces and supports reusable UI components.

### Dart

Dart is used as the programming language for the Flutter application and provides the implementation foundation for the application logic and UI.

### Material 3

Material 3 is used as the base design system for consistent components, typography, spacing and application theming.

### fl_chart

The `fl_chart` package is used to render time-series physiological measurements as line charts.

### Synthetic Data

Synthetic data is used to simulate changing physiological measurements without depending on real hardware, confidential systems or a production backend.

This keeps the prototype reproducible and allows the data handling and visualization workflow to be tested independently.

## Data Flow

VitalSense uses synthetic physiological data to simulate a continuously changing monitoring experience.

### Data Flow Diagram

Application Start
       |
       v
   main.dart
       |
       v
DashboardScreen
       |
       v
MockDataService
       |
       +----------------------+
       |                      |
       v                      v
Historical Data        Live Data Generator
       |                      |
       |                      v
       |                Data Validation
       |                      |
       |                Valid Measurement
       |                      |
       +----------+-----------+
                  |
                  v
       PhysiologicalData Model
                  |
                  v
        Dashboard State
                  |
        +---------+---------+
        |         |         |
        v         v         v
   Metric Cards  Charts  Status
        |         |         |
        +---------+---------+
                  |
                  v
           User Interface

### Data Flow Steps
1. Application Initialization

The application starts from main.dart and loads the DashboardScreen.

2. Historical Data Loading

The dashboard requests synthetic historical measurements from MockDataService.

The service returns a list of PhysiologicalData objects containing timestamped physiological measurements.

3. Data Storage in Dashboard State

The dashboard stores the measurements in its local state.

The stored measurements are used to display the latest values and generate time-series charts.

4. Live Measurement Generation

The application periodically generates a new synthetic measurement using MockDataService.

The live update cycle runs every 5 seconds.

5. Data Validation

Before a newly generated measurement is added to the dashboard, it is validated using the data validation logic.

Invalid measurements are not added to the displayed dataset.

6. Time Range Filtering

The dashboard supports selectable time ranges:

1H
6H
24H

The selected range determines which measurements are displayed in the time-series charts.

7. UI Update

When a valid measurement is added, the dashboard updates the metric cards, monitoring status and charts.

This allows the prototype to demonstrate continuously changing physiological measurements.

8. Data Limit

The dashboard maintains a maximum of 50 measurements during live monitoring to keep the prototype lightweight.

9. UI States

The dashboard also handles different application states including:

   - Loading
   - Empty data
   - Invalid data
   - Error
   - Delayed or changing measurements
   - Data Source

The current prototype uses locally generated synthetic data.

No real medical device, MindCare production system or external physiological data API is connected to the application.

## Time Range Interaction
The dashboard provides three selectable time ranges:

1H - last 1 hour
6H - last 6 hours
24H - last 24 hours

The selected range filters the available measurements before displaying them in the charts.

## Validation
Incoming measurements are validated before being added to the dashboard
The prototype checks for:

   - Empty data
   - Invalid physiological values
   - Invalid numeric values
   - Invalid blood pressure values
Invalid measurements are ignored rather than being displayed.

## Running the Project
Requirements
   - Flutter SDK
   - Dart SDK
   - Android Studio or another Flutter-supported development environment
   - Android device/emulator or another supported Flutter device

## Installation
Clone or copy the project and open the project directory.

Run:
flutter pub get

Then verify the project:
flutter analyze

Run the tests:
flutter test

Run the application:
flutter run

## Testing
The project includes Flutter widget testing.
The current test verifies that:
   - The VitalSense application loads successfully
   - Current Measurements section is displayed
   - Heart Rate metric is displayed
   - SpO₂ metric is displayed
   - Temperature metric is displayed
   - Blood Pressure metric is displayed

## Additional manual verification covers:
   - Live measurement updates
   - Time-range selection
   - Loading state
   - Empty-data state
   - Invalid-data handling
   - Error handling
   - Responsive mobile layout

## Limitations
   - The application currently uses synthetic/mock physiological data.
   - No real physiological hardware is connected.
   - No production backend or external API is used.
   - The prototype does not store historical measurements permanently.
   - Status thresholds are demonstration rules for the prototype and are not intended to provide medical diagnosis.
   - Authentication and user-specific data management are not included.
    
## Future Improvements
Possible future improvements include:
   - Real sensor or API integration
   - Secure backend integration
   - Persistent historical data storage
   - User authentication
   - Push notifications
   - Advanced anomaly detection
   - More detailed historical analysis
   - Production monitoring and logging
   - Accessibility improvements
   - Additional automated tests

## Project Status
VitalSense is a functional mobile prototype demonstrating real-time physiological data visualization, validation, responsive UI, reusable components, and basic testing.

This prototype is an independent engineering implementation and should not be interpreted as the final architecture or implementation of any external organization.