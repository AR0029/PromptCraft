# PromptCraft 🚀
### Master the Art of AI Communication

**PromptCraft** is a premium, high-performance Flutter application designed to transform simple ideas into sophisticated "Mega-Prompts" optimized for the world's most powerful AI models (GPT-4, Claude 3, Gemini, Midjourney, etc.).

[![Deploy flutter web to GitHub Pages](https://github.com/AR0029/PromptCraft/actions/workflows/deploy.yml/badge.svg)](https://github.com/AR0029/PromptCraft/actions/workflows/deploy.yml)
[![Live Demo](https://img.shields.io/badge/Live-Demo-brightgreen)](https://AR0029.github.io/PromptCraft/)

---

## ✨ Features

- **🧠 Intelligent Mega-Prompt Engine**: Converts minimal user inputs into deeply structured Markdown prompts using advanced prompt engineering patterns (Identity, Context, Constraints, Few-shot examples).
- **📊 Prompt Quality Index**: Real-time scoring of your prompt's effectiveness with actionable AI-driven tips for improvement.
- **🎨 Premium UX/UI**: A stunning, modern interface featuring glassmorphism, fluid animations (via `flutter_animate`), and responsive design for Web, iOS, and Android.
- **📁 Local Prompt Library**: Save, favorite, and manage your most effective prompts locally using Hive.
- **🌗 Dynamic Theming**: Fully functional Light and Dark modes with persistent user preferences.
- **⚡ High Performance**: Built with Flutter and Riverpod for a smooth, high-frame-rate experience across all platforms.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Stable Channel)
- **State Management**: [Riverpod](https://riverpod.dev/) (Global providers & local UI state)
- **Local Database**: [Hive](https://docs.hivedb.dev/) (NoSQL, high-speed persistence)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Typography**: [Google Fonts (Outfit)](https://pub.dev/packages/google_fonts)
- **CI/CD**: GitHub Actions (Auto-deploy to GitHub Pages)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable)
- Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AR0029/PromptCraft.git
   cd PromptCraft
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters:**
   *Essential for the local storage to function.*
   ```bash
   dart run build_runner build -d
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📦 Deployment & Building

### Web (GitHub Pages)
The app is configured with a GitHub Action. Every push to `main` automatically builds and deploys the latest version to [GitHub Pages](https://AR0029.github.io/PromptCraft/).

### Android (.apk)
To generate a release build for Android:
```bash
flutter build apk --release
```

### iOS / Desktop
For iOS builds, use **Codemagic** or a macOS machine with Xcode:
```bash
flutter build ios --release
```

---

## 🏗️ Project Structure

```text
lib/
├── core/             # Design system, themes, and global constants
├── data/             # Models and persistence logic
├── features/         # Feature-first folder structure
│   ├── home/         # Dashboard & Category Grid
│   ├── prompt_builder/# Form logic & Generator Engine
│   ├── library/      # Saved & Favorite prompts
│   └── settings/     # Theme & Data management
├── navigation/       # Riverpod-powered routing & scaffold
└── services/         # Logic services (Generator, Storage)
```

---

## 👨‍💻 Author
**Made with passion by Aryan Chaudhary**

---

## ⚖️ License
Licensed under the [MIT License](LICENSE).
