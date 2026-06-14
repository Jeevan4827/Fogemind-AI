# ForgeMind AI - Mobile Application

ForgeMind AI is a next-generation, AI-native industrial operations platform. This mobile app is designed for floor supervisors and maintenance technicians to act as a powerful Operations Copilot, transforming static factory data into actionable, natural language insights.

## Features

- **Operations Copilot (Voice & Text):** Ask complex operational questions in plain language (e.g., *"Why did Line A production drop?"*). The AI synthesizes data across production, maintenance, and energy sensors to provide root-cause analysis.
- **AI Insights Feed:** Instead of staring at dense dashboards, users receive a social-media style feed of auto-generated insights, anomalies, and shift summaries.
- **AR Maintenance Scan (Mockup):** Point your camera at a machine's QR code to instantly pull up live telemetry, open maintenance tickets, and overall health scores.
- **Live MySQL Integration:** The app is configured for quick hackathon-style direct database connections to fetch real-time health scores and log AI interactions.
- **Futuristic UI:** Built using Flutter with a high-performance dark mode, glassmorphic design elements, and fluid animations.

## Architecture

This Flutter application bypasses the traditional REST API layer for the sake of an immediate hackathon demo, communicating directly with a MySQL database.

- **Frontend:** Flutter & Dart
- **UI Libraries:** `google_fonts`, `flutter_animate`, `material3`
- **Database Connection:** `mysql_client`
- **Backend:** MySQL (Local / Cloud)

## Getting Started

### 1. Database Setup

1. Open your MySQL client (e.g., phpMyAdmin, MySQL Workbench).
2. Run the provided `mysql_setup.sql` script located in the root of the project to initialize the `forgemind_db` database and insert demo data.

### 2. Configure Database Connection

1. Open `lib/services/db_service.dart`.
2. Locate the `connect()` function.
3. Update the credentials with your local or cloud MySQL database information:
   ```dart
   host: '192.168.1.x', // Use 10.0.2.2 for Android Emulator, or your IPv4 address
   port: 3306,
   userName: 'root', // Or your specific DB user
   password: 'YourPasswordHere',
   databaseName: 'forgemind_db',
   ```

### 3. Run the App

1. Ensure you have Flutter installed and an emulator/device connected.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the project:
   ```bash
   flutter run
   ```

## Demo Scenarios

- **Scenario 1:** Launch the app and check the AI Insights Feed. Tap the refresh button to see real-time updates if data changes in the DB.
- **Scenario 2:** Navigate to the Copilot tab. Ask *"Why was Line A production low yesterday?"* Watch the AI simulate synthesis across multiple agents and log the transaction directly into your `copilot_logs` MySQL table.

## Hackathon Context

This project was developed rapidly as part of an AI Hackathon. The focus is on demonstrating a paradigm shift in industrial software UI/UX, moving from passive dashboards to an active, reasoning "Copilot" architecture.
