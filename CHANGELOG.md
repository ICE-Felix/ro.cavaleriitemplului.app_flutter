# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0+6] - 2024-03-26

### Updated
- **Version Bump** - Incremented build number for new release
- **News Feature** - Various improvements and bug fixes in news feature implementation
- **Repository Layer** - Enhanced news repository implementation
- **UI Components** - Refined news detail page and saved articles functionality

## [1.3.4] - 2025-01-06

### Fixed
- **Bundle Identifier Issue** - Changed from "com.mommyhai.app.new" to "com.mommyhai.app.mobile" to avoid Java keyword conflict
- **Java Keyword Conflict** - Resolved build failure where "new" is a reserved Java keyword and cannot be used in package names
- **Package Structure** - Updated Android namespace and applicationId in build.gradle.kts to use valid identifier
- **iOS Bundle Sync** - Updated iOS bundle identifier in project.pbxproj to match Android changes

### Added
- **Android Release Signing** - Set up complete Android keystore configuration for release builds
- **CI/CD Preparation** - Added key.properties template and keystore management for Codemagic deployment
- **Build Security** - Added .gitignore entries to protect signing credentials and keystore files
- **Release Build Testing** - Successfully generated signed app-release.aab (24.5MB) for deployment testing

### Enhanced
- **Package Organization** - Moved MainActivity.kt to correct package structure (com.mommyhai.app.mobile)
- **Build Validation** - Verified complete release build pipeline with proper signing
- **Deployment Readiness** - Prepared project for automated CI/CD deployment to Google Play and TestFlight
- **Credential Management** - Established secure handling of signing credentials for production builds

### Technical Improvements
- Updated Android namespace from "com.mommyhai.app.new" to "com.mommyhai.app.mobile"
- Updated iOS bundle identifier across all build configurations (Debug, Release, Profile)
- Created Android keystore with RSA 2048-bit key valid for 10,000 days
- Configured build.gradle.kts to use environment variables for CI/CD signing
- Successfully tested release build generation with Font Awesome and Material Icons optimization
- Prepared project structure for Codemagic workflow configuration

## [1.3.3] - 2025-01-06

### Added
- **App Icons Configuration** - Integrated flutter_launcher_icons package for automated icon generation
- **Multi-Platform Icons** - App icons now properly configured for Android, iOS, web, Windows, and macOS
- **High-Quality Icon Assets** - Using 1024x1024 source image for optimal quality across all platforms
- **Icon Size Optimization** - Automatic generation of all required icon sizes for each platform

### Updated
- **App Name** - Changed from "app" to "Mommy HAI" across all platforms
- **Bundle Identifier** - Updated from "com.mommyhai.app" to "com.mommyhai.app.new" for unique app identity
- **Android Configuration** - Updated AndroidManifest.xml with new app name and package structure
- **iOS Configuration** - Updated Info.plist with new app name and bundle identifier
- **Package Structure** - Moved MainActivity.kt to new package directory structure

### Enhanced
- **App Store Readiness** - Icons now comply with App Store requirements (alpha channel removed for iOS)
- **Brand Identity** - Consistent "Mommy HAI" branding across all platforms and configurations
- **Platform Consistency** - Unified app name and identifier structure for Android and iOS
- **Build Configuration** - Updated build.gradle.kts with new namespace and application ID

### Technical Improvements
- Added flutter_launcher_icons: ^0.14.1 to dev dependencies
- Updated Android namespace from "com.mommyhai.app" to "com.mommyhai.app.new"
- Updated iOS bundle identifier in all build configurations (Debug, Release, Profile)
- Updated test bundle identifiers to match new package structure
- Cleaned and rebuilt project dependencies for fresh configuration

## [1.3.2] - 2025-01-06

### Fixed
- **Intro Animation Flow** - Fixed intro sequence to always show logo fade-in animation with purple background transition on app startup
- **App Navigation** - Corrected app flow to display intro animation before checking authentication status
- **User Experience** - Restored beautiful intro sequence for all users, regardless of authentication status

### Enhanced
- **Intro Sequence** - Logo fade-in animation (1.5s) followed by background transition (2s) and 2-second pause
- **Authentication Check** - Moved authentication check to occur after intro animation completes
- **Navigation Logic** - Improved navigation flow: Intro → Auth Check → News/Login based on auth status

### Technical Improvements
- Updated AppInitializer to always show IntroPage first
- Enhanced IntroPage with MultiBlocListener for proper auth state management
- Fixed import statements and dependencies in intro feature

## [1.3.1] - 2025-01-06

### Fixed
- **API Response Structure** - Updated NewsResponseModel to handle new API response format where data is directly in the 'data' array and pagination is under 'meta.pagination'
- **Pagination Parsing** - Fixed pagination parsing to correctly extract hasNext and other pagination metadata from the new API structure

### Enhanced
- **News Pagination** - Increased default limit from 1 to 5 items per page for better user experience
- **API Compatibility** - Ensured full compatibility with the updated news API endpoint structure
- **Search Functionality** - Confirmed search feature is fully functional with real API integration using '/functions/v1/news?search=' endpoint

### Verified Features
- **Real-time Search** - Search input triggers immediate API calls with search parameter
- **Search Results Display** - Proper UI state management for search results with pagination support
- **Search API Integration** - Confirmed compatibility with search endpoint returning filtered results with metadata

### Technical Improvements
- Updated NewsResponseModel.fromJson() to parse the new response structure
- Modified toJson() method to match the new API format
- Updated all default limit parameters across data sources, repositories, and use cases
- Verified search functionality works correctly with existing implementation

## [1.3.0] - 2025-01-06

### Added
- **Real API Integration** - Switched from mock data to actual Supabase API endpoints for news and categories
- **Category API Support** - Fetch news categories dynamically from `/functions/v1/news_categories` endpoint
- **News API Integration** - Implemented news fetching from `/functions/v1/news` endpoint with pagination, search, and category filtering
- **Category Model** - New data model to handle category API response structure with ID, name, and timestamps
- **UUID Support** - Updated news and bookmark systems to use string IDs instead of integers for API compatibility
- **Category Filtering by ID** - News filtering now uses category UUIDs (`category_id` parameter) instead of names
- **Dynamic Category Display** - Category chips now display real category names fetched from the API
- **Enhanced Error Handling** - Improved error messages and fallback mechanisms for API failures

### Enhanced
- **Authentication Headers** - All API calls now properly include authentication tokens and required headers
- **Network Request Structure** - Standardized HTTP GET requests with proper query parameters for pagination and filtering
- **Category Management** - Categories are now fetched dynamically and stored as objects with full metadata
- **Search Functionality** - Search now uses the real API with proper query parameter handling
- **Database Schema** - Updated bookmark storage to use string IDs matching the API response format

### Technical Improvements
- **Type Safety** - Updated all ID references from `int` to `String` for UUID compatibility
- **API Response Handling** - Proper parsing of nested API responses with success/error checking
- **State Management** - Updated BLoC states to handle CategoryModel objects instead of strings
- **Repository Pattern** - Enhanced repositories to work with real API endpoints
- **Use Case Updates** - All use cases now work with the new API data structures
- **Mock Data Fallback** - Graceful fallback to mock data when API calls fail

### Fixed
- **Category Filtering** - Fixed category filtering to use proper `category_id` parameter with UUID values
- **Authentication Flow** - Ensured all API calls include proper authentication headers
- **Data Consistency** - Resolved type mismatches between mock data and real API response formats
- **Database Migration** - Updated local database schema to handle string-based news IDs

## [1.2.0] - 2024-12-20

### Added
- **News Feature** - Complete news reading functionality with article browsing and search
- **Article Bookmarking** - Save and manage favorite articles with persistent storage
- **News Categories** - Browse news by different categories and topics
- **Article Search** - Search through news articles with keyword filtering
- **Saved Articles Page** - Dedicated page to view and manage bookmarked articles
- **Database Integration** - SQLite database helper for local data persistence
- **Custom Top Bar Widget** - Reusable top navigation bar component
- **App Initializer** - Centralized app initialization and routing logic
- **Authentication Persistence** - Check and maintain user authentication state
- **Logo Assets** - Added brand logo assets including line variant

### Enhanced
- **Authentication System** - Improved auth flow with persistent login state
- **Local Data Storage** - Added local data sources for offline functionality
- **Service Locator** - Enhanced dependency injection with new services
- **BLoC Architecture** - Extended state management for news and bookmarks
- **Repository Pattern** - Implemented repositories for news and bookmark data
- **Use Cases** - Added comprehensive use cases for all new features

### Technical Improvements
- Clean architecture maintained across all new features
- Mock data sources for development and testing
- Comprehensive error handling for network and database operations
- Proper separation of concerns with data, domain, and presentation layers
- Enhanced type safety and null handling throughout the codebase

### Dependencies Added
- SQLite support for local database operations
- Enhanced network connectivity handling
- Improved state management patterns

## [1.1.1] - 2024-12-20

### Fixed
- **Robust Network Connectivity Checking** - Enhanced network detection to perform actual internet connectivity tests
- **Real Internet Connection Validation** - Added DNS lookup verification to ensure genuine internet access
- **Improved Network Error Handling** - Better detection of offline scenarios with comprehensive logging
- **Fixed Animated Background Widget** - Resolved Positioned widget placement issue inside Stack container
- **Enhanced Debug Logging** - Added detailed network connectivity debugging for better troubleshooting

### Technical Improvements
- Implemented dual-layer network checking: device connectivity + actual internet access
- Added DNS lookup to google.com for reliable internet connection verification
- Fixed Flutter widget tree structure for proper rendering
- Enhanced error reporting with specific network failure reasons
- Improved user experience with accurate offline detection

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