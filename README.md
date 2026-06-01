# QuickPOS Flutter Desktop

QuickPOS is a small point-of-sale desktop demo built with Flutter Desktop and connected to a C# ASP.NET Core Web API backend.

I built this project as a fast learning exercise to show that I can pick up Flutter Desktop patterns, integrate with a C# backend, and deliver a usable desktop workflow in a short time.

## Demo Scope

- Desktop-first POS layout for Windows
- Product browsing with category filters
- Product search by name or barcode
- Cart management with quantity changes and clear cart
- Payment method selection
- Checkout flow through the backend API
- Receipt dialog after a successful sale
- Sales history dialog
- Configurable backend base URL from the app settings
- Clean Flutter structure using Cubit, repositories, models, and a shared API client

## Tech Stack

- Flutter Desktop
- Dart
- flutter_bloc for state management
- dio for HTTP requests
- shared_preferences for saved settings
- intl for date/time and receipt formatting
- C# ASP.NET Core Web API backend in a separate repository

## Backend API

The app expects the backend server to run at:

```text
https://localhost:7143
```

The URL can also be changed inside the desktop app from the settings button.

Main API routes used by the Flutter app:

```text
GET  /api/products
GET  /api/products?barcode={barcode}
POST /api/sales/checkout
GET  /api/sales?take=20
```

## Running the App

Install dependencies:

```bash
flutter pub get
```

Run on Windows desktop:

```bash
flutter run -d windows
```

Optionally run with a custom backend URL:

```bash
flutter run -d windows --dart-define=SERVER_BASE_URL=https://localhost:7143
```

## Verification

The project currently passes:

```bash
flutter analyze
flutter test
```

## Screenshots

Screenshots are included with the demo submission to show the product grid, cart, checkout receipt, and sales history flow.

## Notes

This is intentionally a compact demo, not a full production POS. The goal is to demonstrate fast ramp-up, desktop UI implementation, API integration, and practical project organization across Flutter Desktop and a C# backend.
