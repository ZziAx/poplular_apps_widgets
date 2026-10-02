# Popular Apps Widgets

A collection of reusable **Flutter widgets inspired by popular applications**.

The goal of this project is to recreate interesting UI components and interaction patterns from well-known apps while keeping the implementation modular, reusable, and easy to integrate into other Flutter projects.

## ✨ Features

* 📱 Reusable Flutter UI components
* 🧩 Modular widget architecture
* 🎨 App-inspired UI implementations
* 📜 Custom scrolling and pinned headers
* ⚡ Smooth animations and interactions
* 🏗️ Reusable controllers and core widgets
* 🔌 Designed to be integrated into other Flutter projects

## 📦 Widgets

Currently, the project includes components inspired by:

### Telegram

* Telegram-style header
* Tab bar
* Scrollable header
* Pinned header behavior
* Custom scroll interactions

More applications and widgets will be added over time.

## 🏗️ Project Structure

The project separates **app-specific widgets** from reusable **core components** and controllers.

## 🚀 Getting Started

### Requirements

* Flutter
* Dart
* A Flutter-compatible IDE such as Android Studio or VS Code

### Installation

Clone the repository:

```bash
git clone https://github.com/ZziAx/popular_apps_widgets.git
```

Navigate to the project:

```bash
cd popular_apps_widgets
```

Install dependencies:

```bash
flutter pub get
```

Run the project:

```bash
flutter run
```

## 🧱 Architecture

The project is organized around three main concepts:

### Apps

App-specific implementations live under:

```text
src/apps/
```

For example:

```text
src/apps/telegram/
```

This keeps widgets related to a particular application isolated from the reusable infrastructure.

### Core Widgets

Reusable UI infrastructure lives under:

```text
src/core/widgets/
```

These widgets are designed to be independent of a specific application whenever possible.

### Controllers

Reusable behavior and state management logic lives under:

```text
src/controllers/
```

For example, the project contains a controller for managing pinned scrolling behavior.

## 🎯 Project Goals

This project is primarily focused on experimenting with and implementing:

* Advanced Flutter layouts
* Custom scrolling behavior
* Sliver-based interfaces
* Pinned headers
* Widget composition
* Animation and interaction
* Reusable Flutter architecture
* Reverse engineering UI patterns from popular applications

It is also intended as a practical collection of Flutter UI experiments and reusable components.

## 🛠️ Technologies

* **Flutter**
* **Dart**
* Flutter Material
* Custom Scroll Controllers
* Slivers
* Custom reusable widgets

## 📸 Screenshots

Screenshots and demonstrations of individual widgets will be added as the project grows.

## 🤝 Contributing

Contributions, improvements, and new widget implementations are welcome.

If you have an interesting UI component inspired by a popular application, feel free to open an issue or submit a pull request.

## ⚠️ Disclaimer

This project is an independent implementation for educational and development purposes.

It is **not affiliated with, sponsored by, or endorsed by Telegram or any other application referenced in this repository**.

All product names, logos, and trademarks belong to their respective owners.

## 📄 License

This project is available under the license included in this repository.
