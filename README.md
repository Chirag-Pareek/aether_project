# Aether Concurrency & UI Dashboard 🐉⚡

A high-performance, real-time MMORPG event manager built with Flutter and Firebase. This project demonstrates advanced concurrency handling, drift-free high-frequency UI updates, and a premium responsive design system.

## ⚙️ Setup

1. Clone the repo and run `flutter pub get`.
2. Copy `.env.example` to `.env` and fill in your Firebase credentials:
   ```
   cp .env.example .env
   ```
3. Run the app with `flutter run`.

> **Note:** The `.env` file is gitignored to protect secrets. Without it, the app will crash on launch. Use `.env.example` as a template.

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

## 💰 Firebase Cost Strategy (10,000 Concurrent Users)

Chat messages are stored in a subcollection under each event document, and every client listener is capped at `.limit(50)` — meaning each of the 10,000 clients reads at most 50 documents regardless of total message history, keeping reads at a flat O(1) per user rather than O(collection size). All messages use `FieldValue.serverTimestamp()` so ordering is consistent without extra reads. Older message history is loaded only on explicit user scroll (pagination on demand), so the baseline cost stays constant even as the chat grows to millions of messages.

## 🛠️ Tech Stack
- **State Management**: BLoC (WorldEventBloc)
- **Database**: Cloud Firestore (Real-time Streams + Transactions)
- **Design**: Retro RPG pixel aesthetic with custom sprite sheet integration

## 🛡️ Quality Assurance
- **Lints**: 0 Warnings (Strict analysis — `flutter analyze` clean)
- **Tests**: High-concurrency thundering herd verified
- **Performance**: Optimized for low-end devices via RepaintBoundaries

---
*Built for the Aether World Event Challenge.*
