# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2024-12-20

### Added
- Intro feature with animated splash screen
- Network connectivity checking on app startup
- Beautiful brand introduction with logo animation
- Smooth background color transition from light to dark theme
- Auto-navigation to authentication after intro completion
- PNG logo asset support in intro animation
- Error handling for offline scenarios with retry functionality

### Updated
- App theme colors updated to use #F9F9F9 (light) and #4D217B (dark purple) backgrounds
- Color scheme modernized with new brand colors
- Removed deprecated `background` property from ColorScheme
- Fixed meta import issues by using Flutter foundation library
- Improved BuildContext handling across async gaps
- Replaced deprecated type literal patterns with modern Dart syntax

### Technical Improvements
- Enhanced BLoC pattern implementation for intro flow
- Clean architecture maintained with domain, data, and presentation layers
- Proper animation controller management and disposal
- Sequential animation timing with logo fade-in followed by background transition
- 2-second pause on final state before navigation

## [1.0.0] - 2024-12-20

### Added
- Initial Flutter project setup
- Clean architecture implementation with core, features, and presentation layers
- Authentication system with login, signup, and forgot password functionality
- Supabase integration for backend services
- Dio HTTP client for API communication
- BLoC state management pattern
- Custom UI components (buttons, text fields)
- Environment configuration with .env file
- Network connectivity checking
- iOS and Android platform support
- Core utilities and service locator pattern

### Dependencies
- flutter_bloc: ^9.1.1 - State management
- supabase_flutter: ^2.9.1 - Backend services
- dio: ^5.8.0+1 - HTTP client
- connectivity_plus: ^6.1.4 - Network connectivity
- flutter_dotenv: ^5.2.1 - Environment variables
- get_it: ^8.0.3 - Dependency injection
- equatable: ^2.0.7 - Value equality
- font_awesome_flutter: ^10.8.0 - Icons

### Project Structure
- `/lib/core/` - Core utilities, constants, and shared components
- `/lib/features/auth/` - Authentication feature with data, domain, and presentation layers
- Clean architecture with separation of concerns
- Repository pattern for data access
- Use cases for business logic
- BLoC for state management 