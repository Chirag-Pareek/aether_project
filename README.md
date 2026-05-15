# Aether Concurrency & UI Dashboard 🐉⚡

A high-performance, real-time MMORPG event manager built with Flutter and Firebase. This project demonstrates advanced concurrency handling, drift-free high-frequency UI updates, and a premium responsive design system.

## 🚀 Architectural Highlights

### 1. "Thundering Herd" Protection
To handle high-concurrency raid joins (e.g., 50+ users hitting the 'Join' button at the same millisecond), the `RaidService` implements **Firestore Atomic Transactions**. 
- **Mechanism**: A read-check-write transaction ensures that the slot count is never exceeded, even under extreme load.
- **Verification**: Validated by `raid_concurrency_test.dart`, confirming exactly 15 slots are filled out of 50 simultaneous requests.

### 2. "Global Pulse" Timer (100ms Precision)
The UI features a drift-free countdown timer with 100ms precision.
- **Surgical Repaints**: Built using `ValueNotifier` and `RepaintBoundary`. This ensures that only the specific pixels of the timer text are redrawn 10 times per second, preventing full widget-tree rebuilds and maintaining 60+ FPS.
- **Drift Correction**: Calculated against the system clock to ensure zero timing drift over long periods.

### 3. Real-Time Tactical Stream
A cost-safe, real-time chat integrated directly into the dashboard.
- **Scalability**: Queries are limited to the last 50 messages to ensure low read costs and high performance.
- **Global Sync**: Uses `FieldValue.serverTimestamp()` to ensure perfectly synchronized message ordering across global players.

### 4. Premium Design System
- **Responsive Layout**: Adapts seamlessly to Phone, Tablet, and Landscape modes using a custom `MediaScreen` utility.
- **Adaptive Aesthetics**: Features a dynamic theme system with smart icon contrast and premium gradients that adapt to System Dark/Light settings.

## 🛠️ Tech Stack
- **State Management**: BLoC (WorldEventBloc)
- **Database**: Cloud Firestore (Real-time Streams + Transactions)
- **Design**: Vanilla CSS-inspired Flutter Widgets + Watchflo Port

## 🛡️ Quality Assurance
- **Lints**: 0 Warnings (Strict analysis)
- **Tests**: High-concurrency verified
- **Performance**: Optimized for low-end devices via RepaintBoundaries

---
*Built for the Aether World Event Challenge.*
