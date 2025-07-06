# Changelog

All notable changes to this project will be documented in this file.

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