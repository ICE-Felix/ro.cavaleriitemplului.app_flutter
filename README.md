# Mommy HAI

An AI-powered parenting companion app built with Flutter, featuring clean architecture and modern design patterns.

## 🚀 Features

### 🎬 Intro Experience
- **Animated Splash Screen** - Beautiful brand introduction with logo animation
- **Robust Network Connectivity Check** - Dual-layer internet validation with DNS lookup verification
- **Real Internet Connection Testing** - Goes beyond device connectivity to ensure actual internet access
- **Smooth Transitions** - Light to dark background animation with logo fade-in
- **Smart Error Handling** - Graceful offline experience with detailed error messaging and retry functionality
- **Comprehensive Debug Logging** - Detailed network connectivity debugging for troubleshooting

### 🔐 Authentication System
- **User Registration** - Create new accounts with email validation
- **Secure Login** - User authentication with Supabase backend
- **Password Recovery** - Forgot password functionality
- **Form Validation** - Comprehensive input validation and error handling

### 🎨 Design & Theme
- **Modern UI** - Clean, professional interface design
- **Brand Colors** - Light (#F9F9F9) and dark (#4D217B) theme support
- **Custom Components** - Reusable buttons, text fields, and widgets
- **Responsive Design** - Optimized for iOS and Android devices

## 🏗️ Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                 # Shared utilities and constants
│   ├── constants/        # App constants
│   ├── error/           # Error handling
│   ├── network/         # Network utilities
│   ├── style/           # App themes and colors
│   └── usecases/        # Base use case classes
├── features/            # Feature modules
│   ├── intro/           # Intro/splash feature
│   │   ├── data/        # Data sources and repositories
│   │   ├── domain/      # Entities, repositories, use cases
│   │   └── presentation/ # BLoC, pages, widgets
│   └── auth/            # Authentication feature
│       ├── data/        # Data sources and repositories
│       ├── domain/      # Entities, repositories, use cases
│       └── presentation/ # BLoC, pages, widgets
└── main.dart            # App entry point
```

## 🛠️ Tech Stack

- **Flutter** - Cross-platform mobile development
- **BLoC Pattern** - State management with flutter_bloc
- **Supabase** - Backend-as-a-Service for authentication and data
- **Clean Architecture** - Separation of concerns and testability
- **Get It** - Dependency injection
- **Dio** - HTTP client for API communication

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1      # State management
  supabase_flutter: ^2.9.1  # Backend services
  dio: ^5.8.0+1             # HTTP client
  connectivity_plus: ^6.1.4 # Network connectivity
  get_it: ^8.0.3            # Dependency injection
  equatable: ^2.0.7         # Value equality
  font_awesome_flutter: ^10.8.0 # Icons
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK
- iOS/Android development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Create a `.env` file in the root directory
   - Add your Supabase configuration

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎯 App Flow

1. **Intro Screen** - Animated logo with network check
2. **Authentication** - Login or create account
3. **Main App** - (Coming soon)

## 🔧 Development

### Project Structure
- **Domain Layer** - Business logic and entities
- **Data Layer** - Data sources and repository implementations  
- **Presentation Layer** - UI components and state management

### Code Quality
- Clean Architecture principles
- SOLID design principles
- Comprehensive error handling
- Modern Dart features and patterns

## 📱 Supported Platforms

- ✅ iOS (12.0+)
- ✅ Android (API 21+)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Follow the established architecture patterns
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

Built with ❤️ using Flutter
