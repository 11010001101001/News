# 📰 News

[![Xcode](https://img.shields.io/badge/Xcode-27.0%2B-blue.svg?style=for-the-badge&logo=xcode)](https://developer.apple.com/xcode/)
[![iOS](https://img.shields.io/badge/iOS-27.0%2B-blue.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-purple.svg?style=for-the-badge&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Architecture](https://img.shields.io/badge/Architecture-Modular%20SPM-brightgreen.svg?style=for-the-badge&logo=swift)](https://swift.org/package-manager/)
[![SwiftData](https://img.shields.io/badge/SwiftData-Persistence-green.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/documentation/swiftdata)
[![ActivityKit](https://img.shields.io/badge/ActivityKit-Live%20Activities-red.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/documentation/activitykit)
[![Metal](https://img.shields.io/badge/Metal-Shaders-black.svg?style=for-the-badge&logo=metal)](https://developer.apple.com/metal/)
[![Tests](https://img.shields.io/badge/Tests-Unit%20%2B%20UI%20Coverage-success.svg?style=for-the-badge&logo=xcode)](https://developer.apple.com/documentation/testing)

![demo](.github/assets/demo1.jpg)
![Unknown](.github/assets/demo2.jpg)

**News** is an enterprise-grade, high-performance iOS news application built with a modern **Modular SPM Architecture**, SwiftUI, SwiftData, Swift 6 Concurrency (`ApproachableConcurrency`), Metal Shaders, and ActivityKit. Designed with a custom glassmorphism design system, instant runtime multi-language localization via native String Catalogs, and comprehensive Unit and UI test coverage.

---

## 🏛️ Modular Architecture (Swift Package Manager)

The codebase is fully decoupled into 5 isolated local Swift Packages (`Packages/`), enforcing strict boundary encapsulation, fast parallel compilation, and zero `.pbxproj` merge conflicts without relying on third-party project generators.

```
                   ┌────────────────────────┐
                   │    App (Host & DI)     │
                   └───────────┬────────────┘
                               │
                               ▼
                   ┌────────────────────────┐
                   │        Features        │
                   │ (Main, Details, Sets)  │
                   └───┬────────┬───────┬───┘
                       │        │       │
         ┌─────────────┘        │       └─────────────┐
         ▼                      ▼                     ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   DesignSystem   │  │     CoreKit      │  │    ModelsKit     │
│ (Glass, Lottie)  │  │(Network, Caching)│  │ (SwiftData, DTO) │
└────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
         │                     │                     │
         └─────────────┬───────┴─────────────────────┘
                       ▼
         ┌──────────────────────────┐
         │     LocalizationKit      │
         │  (Native String Catalog) │
         └──────────────────────────┘
```

### Module Breakdown

| Package | Purpose & Boundaries | Key Technologies & Assets |
| :--- | :--- | :--- |
| **`LocalizationKit`** | Single source of truth for app-wide localization | Native String Catalogs (`.xcstrings`), `LocalizedStringResource`, `AccessLevelOnStringCatalogs` |
| **`CoreKit`** | Low-level utilities, networking, and platform abstractions | `CacheManager`, `VibrateManager`, date/string extensions, UIKit wrappers |
| **`ModelsKit`** | Domain models, DTOs, SwiftData entities, and widget schemas | SwiftData schemas, network DTOs, widget timeline entries, `HttpStatusCodes` |
| **`DesignSystem`** | Reusable UI design system, tokens, and audio assets | Metal shaders (`Shaders.metal`), Lottie animations, custom sound engine, glassmorphic modifiers (`.glassCard()`) |
| **`Features`** | Feature flows, coordinators, and presentations | MVVM + `@Observable`, `ModuleBuilder` DI, structured task cancellation, context menus |

---

## 🔥 Features & Highlights

- **📦 100% Native SPM Modularization**: Scalable modular architecture with 5 local packages isolating UI components, domain logic, localization, and networking.
- **⚡ Swift 6 Concurrency & Structured Task Cancellation**: Fully compliant with modern Swift Concurrency (`async/await`, `@Observable`, `@MainActor`, `Sendable`, `ApproachableConcurrency`). Network pipelines feature explicit `Task` lifecycle tracking with structured cancellation guards (`Task.isCancelled`, `CancellationError`), preventing race conditions on rapid category switching. Legacy `Combine` is completely removed.
- **🔄 Modern Observation Architecture**: State management modernized with the Swift `@Observable` macro (`SettingsManager` with `@ObservationIgnored` properties and `@MainActor` thread safety), delivering granular reactive UI updates for loader states, themes, and reading caches.
- **🌍 Zero-Restart Dynamic Localization**: Instant runtime language switching (**English 🇬🇧, Russian 🇷🇺, Indonesian 🇮🇩**) directly in settings without restarting the app, powered natively by Apple **String Catalogs (`Localizable.xcstrings`)**, `LocalizedStringResource`, and `.enableExperimentalFeature("AccessLevelOnStringCatalogs")`. Third-party SwiftGen overhead is completely eradicated.
- **📱 Declarative ScenePhase Fastactions**: Home Screen quick shortcuts (`UIApplicationShortcutItem`) decoupled into SwiftUI `ScenePhase` lifecycle routing, enabling clean, race-free deep-linking to *Settings* or *Share*.
- **🧪 Full Automated Test Suite**:
  - **Unit Testing**: Powered by Swift Testing (`import Testing`, `@Test`) covering ViewModels (`MainViewModel`, `SettingsViewModel`), `SettingsManager`, async network pipelines, models, and extensions.
  - **UI Testing**: Automated `XCTest UI` suite (`NewsUITests`) covering navigation flows, settings tabs, favorites, toolbar actions, and scroll interactions.
- **🎨 Metal Shaders**: Custom Metal shader library (`Shaders.metal`) powering real-time shader visual effects (`ShaderLibrary.complexWave`).
- **🌐 WebKit Reader with Dual Progress Lines**: `WKWebView` featuring **KVO estimated progress line** (`NSKeyValueObservation`) and **scroll progress line** (`UIScrollViewDelegate` scroll ratio).
- **📋 Rich Context Menus**: Contextual menus (`.contextMenu`) across cells for quick actions (*Add/Remove Favorites*, *Share*, *Mark as Read/Unread*, *Copy Link*).
- **🏝️ Live Activities & Gamification**: Real-time Lock Screen & Dynamic Island tracking via **ActivityKit**, gamifying user reading progress (*Newbie ➔ Curious Observer ➔ Loop Master ➔ Tech Ninja*).
- **🖼️ Async Cached Image**: High-performance `CachedAsyncImage` pipeline for smooth image loading and memory/disk caching.
- **🔔 Local Notifications**: Scheduled local notifications via `UNUserNotificationCenter` (`UNCalendarNotificationTrigger`) with custom audio themes.
- **🧹 Multi-Package SwiftLint**: Standardized `.swiftlint.yml` at project root covering `App/`, all 5 `Packages/`, `Widgets/`, and `Tests/`.
- **📌 Offline Favorites & Persistence**: SwiftData storage for saved articles, read/unread history, and user preferences.
- **🎨 Glassmorphism & Media Personalization**: Custom glassmorphic UI (`.glassCard()`), 5 Lottie loaders (Rocket 🚀, Hourglass ⏳, Astronaut 👩‍🚀, Hamster 🐹, Kitten 🐱), 3 audio themes (*Star Wars*, *Cats*, *Silent* - modernized with iOS 27 throwing audio APIs), alternate app icons, and haptics.
- **🧩 WidgetKit Widgets**: Static & dynamic Home Screen widgets sharing state via App Groups (`group.news2.0.News`).

---

## 🛠️ Tech Stack

| Component | Technology |
| :--- | :--- |
| **Architecture** | Modular Architecture (5 Local SPM Packages) + MVVM + `@Observable` + `ModuleBuilder` DI |
| **UI Framework** | SwiftUI + UIKit Interoperability (`WKWebView`, `UIActivityViewController`) |
| **Shaders** | Metal (`Shaders.metal`, `ShaderLibrary`) |
| **Persistence** | SwiftData with shared App Group container (`group.news2.0.News`) |
| **Concurrency** | Swift 6 Concurrency (`async/await`, `@MainActor`, `Sendable`, Structured Cancellation, `ApproachableConcurrency`) |
| **State Management**| Swift Observation (`@Observable`, `@ObservationIgnored`, `@MainActor`) |
| **Localization** | Native Apple String Catalogs (`.xcstrings`) + `LocalizedStringResource` + Runtime Switcher |
| **Testing** | Swift Testing (`@Test` Unit Tests) + XCTest (`NewsUITests` UI Tests) |
| **System Integrations** | ActivityKit, WidgetKit, TipKit, AVFoundation, UNUserNotificationCenter, ScenePhase Fastactions |
| **Code Quality** | SwiftLint (`.swiftlint.yml`), `.swift-format` |
| **Dependencies** | Lottie |

---

## 🏗️ Project Structure

```
News/
├── App/                    # Application Entry, App Delegate & App Lifecycle
│   ├── Application/        # NewsApp.swift, Delegates.swift
│   └── Resources/          # Assets.xcassets, Info.plist, Entitlements
├── Packages/               # Modular Local Swift Packages
│   ├── LocalizationKit/    # String Catalogs (.xcstrings), LocalizedStringResource
│   ├── CoreKit/            # Networking, CacheManager, Utilities, Extensions
│   ├── ModelsKit/          # Domain Entities, DTOs, SwiftData Schemas, Widget Models
│   ├── DesignSystem/       # Glassmorphism UI, Metal Shaders, Lottie, Sounds, Tokens
│   └── Features/           # Main, Details, Favorites, Settings Modules & ViewModels
├── Widgets/                # WidgetKit Extension & Live Activities (ActivityKit)
├── Tests/                  # Automated Test Suites
│   ├── NewsTests/          # Swift Testing Unit Tests Suite (@Test)
│   └── NewsUITests/        # XCTest UI Automation Suite
├── Templates/              # Architecture code generation templates
└── .swiftlint.yml          # Multi-package automated linter configuration
```

---

## 🧪 Testing

```bash
# Run Unit Tests (Swift Testing)
xcodebuild test -project News.xcodeproj -scheme News -destination "generic/platform=iOS Simulator" -only-testing:NewsTests

# Run UI Tests (XCTest UI)
xcodebuild test -project News.xcodeproj -scheme News -destination "generic/platform=iOS Simulator" -only-testing:NewsUITests
```

---

## 💻 Requirements

- **Xcode**: 27.0+
- **Swift**: 6.0+ (Swift-Tools 6.4)
- **iOS Target**: 27.0+
