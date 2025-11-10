# Layout & Design System Guide

This document defines the consistent layout patterns, design tokens, and styling guidelines for the Cavalerii Templului Flutter application.

## Table of Contents
- [Color System](#color-system)
- [Typography](#typography)
- [Spacing & Sizing](#spacing--sizing)
- [Border Radius](#border-radius)
- [Elevation & Shadows](#elevation--shadows)
- [Component Patterns](#component-patterns)
- [Layout Guidelines](#layout-guidelines)
- [Best Practices](#best-practices)

---

## Color System

### Primary Colors
```dart
AppColors.primary        // #8B0000 - Dark Red (main brand color)
AppColors.secondary      // #C9A227 - Gold (accent color)
AppColors.error          // #B00020 - Error states
AppColors.success        // #4CAF50 - Success states (green)
AppColors.warning        // #FFC107 - Warning states (amber)
AppColors.info           // #2196F3 - Info states (blue)
```

### Background Colors
```dart
AppColors.background     // #F7F5EF - Warm off-white (scaffold background)
AppColors.surface        // #FFFFFF - White (cards, modals)
AppColors.inputFill      // #F1EFE8 - Input field backgrounds
```

### Text Colors
```dart
AppColors.onSurface      // #1B1B1B - Primary text
AppColors.onBackground   // #1B1B1B - Text on background

// Use with alpha values for variations:
Theme.of(context).colorScheme.onSurface.withValues(alpha: 1.0)   // Primary text
Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)   // Secondary text
Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)   // Tertiary text
Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)   // Disabled text
```

### Border & Divider Colors
```dart
AppColors.border         // #E2DED3 - Standard borders
AppColors.divider        // #E2DED3 - Divider lines
AppColors.focusedBorder  // #A31212 - Focused input borders
```

### Special Colors
```dart
AppColors.snackBarBackground  // #0B1424 - Dark blue-gray for snackbars
AppColors.textButtonColor     // #A88717 - Darker gold for text buttons
```

### Using Theme Colors
Always prefer theme-based colors over hardcoded values:

```dart
// ✅ CORRECT - Theme-aware
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),
)

// ❌ INCORRECT - Hardcoded
Container(
  color: Colors.white,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.black),
  ),
)
```

---

## Typography

### Text Styles
Use theme-based text styles from `AppTextStyles` or `Theme.of(context).textTheme`:

```dart
// Headlines
Theme.of(context).textTheme.headlineLarge    // Large titles
Theme.of(context).textTheme.headlineMedium   // Medium titles
Theme.of(context).textTheme.headlineSmall    // Small titles

// Body Text
Theme.of(context).textTheme.bodyLarge        // Primary body text
Theme.of(context).textTheme.bodyMedium       // Secondary body text
Theme.of(context).textTheme.bodySmall        // Small body text

// Labels
Theme.of(context).textTheme.labelLarge       // Button text
Theme.of(context).textTheme.labelMedium      // Form labels
Theme.of(context).textTheme.labelSmall       // Captions
```

### Font Weights
```dart
FontWeight.bold      // 700 - Headlines, important text
FontWeight.w600      // 600 - Semi-bold for emphasis
FontWeight.normal    // 400 - Body text
FontWeight.w300      // 300 - Light text (use sparingly)
```

---

## Spacing & Sizing

### Standard Spacing Scale
Use multiples of 4 for consistent spacing:

```dart
const EdgeInsets.all(4)      // Extra small - tight spacing
const EdgeInsets.all(8)      // Small - compact elements
const EdgeInsets.all(12)     // Medium - standard spacing
const EdgeInsets.all(16)     // Large - comfortable spacing
const EdgeInsets.all(24)     // Extra large - section spacing
const EdgeInsets.all(32)     // XXL - page padding
const EdgeInsets.all(48)     // XXXL - major sections
```

### Common Padding Patterns
```dart
// Page Padding
padding: const EdgeInsets.all(16)
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24)

// Card Padding
padding: const EdgeInsets.all(16)
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)

// List Item Padding
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)

// Button Padding
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
```

### Sizing Constants
```dart
// Minimum Touch Target
minimumSize: const Size.fromHeight(48)  // Buttons
height: 48.0                            // Input fields

// Icon Sizes
size: 16.0   // Small icons (in text)
size: 20.0   // Medium icons (buttons)
size: 24.0   // Standard icons (app bar, navigation)
size: 32.0   // Large icons (feature icons)
size: 48.0   // XL icons (empty states)
size: 64.0   // XXL icons (splash, onboarding)
```

---

## Border Radius

### Standard Border Radius Values
Use consistent border radius throughout the app:

```dart
BorderRadius.circular(8)    // DEPRECATED - Old value, being phased out
BorderRadius.circular(12)   // Standard - Buttons, chips, inputs, images
BorderRadius.circular(16)   // Large - Cards, modals, bottom sheets
BorderRadius.circular(20)   // XL - Special cases (e.g., FAB)
BorderRadius.circular(24)   // XXL - Large containers
```

### Component-Specific Radius
```dart
// Buttons & Chips
RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))

// Cards
RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))

// Input Fields
OutlineInputBorder(borderRadius: BorderRadius.circular(12))

// Bottom Sheets
borderRadius: const BorderRadius.vertical(top: Radius.circular(24))

// Avatars & Profile Pictures
borderRadius: BorderRadius.circular(999) // Fully circular
```

---

## Elevation & Shadows

### Shadow Patterns
```dart
// Light Shadow (cards on surface)
boxShadow: [
  BoxShadow(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
  ),
]

// Medium Shadow (elevated cards)
boxShadow: [
  BoxShadow(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
]

// Heavy Shadow (modals, dialogs)
boxShadow: [
  BoxShadow(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
    blurRadius: 20,
    offset: const Offset(0, 8),
  ),
]

// Brand Shadow (primary color accent)
boxShadow: [
  BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  ),
]
```

### Material Elevation
```dart
elevation: 0   // Flat (app bars, tabs)
elevation: 1   // Subtle (cards on surface)
elevation: 2   // Standard (cards)
elevation: 4   // Raised (buttons pressed state)
elevation: 8   // Modal (dialogs, bottom sheets)
elevation: 16  // Navigation drawer
```

---

## Component Patterns

### Cards
```dart
Card(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: const EdgeInsets.all(12),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: // Card content
  ),
)

// Alternative: Container-based card
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  padding: const EdgeInsets.all(16),
  child: // Card content
)
```

### Buttons
```dart
// Primary Button (uses theme)
ElevatedButton(
  onPressed: () {},
  child: Text('Primary Action'),
)

// Secondary Button
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Secondary Action'),
)

// Text Button
TextButton(
  onPressed: () {},
  child: Text('Tertiary Action'),
)

// Icon Button
IconButton(
  onPressed: () {},
  icon: Icon(Icons.favorite),
  iconSize: 24,
)
```

### Input Fields
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Hint text',
    prefixIcon: Icon(Icons.email),
    // Theme handles borders, colors, etc.
  ),
  validator: (value) {
    // Validation logic
    return null;
  },
)
```

### Status Badges
```dart
// Success Badge
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: AppColors.success.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.success.withValues(alpha: 0.3),
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check_circle, size: 16, color: AppColors.success),
      const SizedBox(width: 4),
      Text(
        'Open',
        style: TextStyle(
          color: AppColors.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
)

// Error Badge
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: AppColors.error.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.error.withValues(alpha: 0.3),
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.cancel, size: 16, color: AppColors.error),
      const SizedBox(width: 4),
      Text(
        'Closed',
        style: TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
)
```

### SnackBars
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle_outline, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Success message',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
    backgroundColor: AppColors.success,
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(8),
  ),
)
```

### List Items
```dart
ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  leading: CircleAvatar(
    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
    child: Icon(Icons.location_on, color: AppColors.primary),
  ),
  title: Text(
    'Title',
    style: Theme.of(context).textTheme.titleMedium,
  ),
  subtitle: Text(
    'Subtitle',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    ),
  ),
  trailing: Icon(
    Icons.chevron_right,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
  ),
  onTap: () {},
)
```

### Loading States
```dart
// Circular Progress
Center(
  child: CircularProgressIndicator(
    color: AppColors.primary,
  ),
)

// Linear Progress
LinearProgressIndicator(
  color: AppColors.primary,
  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
)

// Shimmer Placeholder (if using shimmer package)
Container(
  width: double.infinity,
  height: 200,
  decoration: BoxDecoration(
    color: AppColors.inputFill,
    borderRadius: BorderRadius.circular(12),
  ),
)
```

### Empty States
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.inbox_outlined,
        size: 64,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      const SizedBox(height: 16),
      Text(
        'No items found',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Try adjusting your filters',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    ],
  ),
)
```

### Error States
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.error_outline,
        size: 64,
        color: AppColors.error,
      ),
      const SizedBox(height: 16),
      Text(
        'Something went wrong',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.error,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Please try again later',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () {
          // Retry action
        },
        child: const Text('Retry'),
      ),
    ],
  ),
)
```

---

## Layout Guidelines

### Page Structure
```dart
Scaffold(
  appBar: AppBar(
    title: Text('Page Title'),
  ),
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Page content
        ],
      ),
    ),
  ),
)
```

### Scrollable Content
```dart
Scaffold(
  appBar: AppBar(title: Text('Title')),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Scrollable content
        ],
      ),
    ),
  ),
)
```

### List Views
```dart
ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: // List item
    );
  },
)

// With separator
ListView.separated(
  padding: const EdgeInsets.all(16),
  itemCount: items.length,
  separatorBuilder: (context, index) => const SizedBox(height: 12),
  itemBuilder: (context, index) => // List item
)
```

### Grid Views
```dart
GridView.builder(
  padding: const EdgeInsets.all(16),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => // Grid item
)
```

### Bottom Sheets
```dart
showModalBottomSheet(
  context: context,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bottom sheet content
      ],
    ),
  ),
)
```

### Dialogs
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    title: Text('Dialog Title'),
    content: Text('Dialog message'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          // Action
          Navigator.pop(context);
        },
        child: const Text('Confirm'),
      ),
    ],
  ),
)
```

---

## Best Practices

### DO ✅
- Use `Theme.of(context)` for colors instead of hardcoded values
- Use `AppColors` constants for semantic colors (primary, success, error, etc.)
- Use `.withValues(alpha: X)` instead of deprecated `.withOpacity(X)`
- Use consistent spacing multiples of 4
- Use border radius of 12 for buttons/chips, 16 for cards
- Use `SafeArea` to avoid notches and system UI
- Use `const` constructors where possible for performance
- Provide semantic names for colors (e.g., `success` instead of `green`)
- Use `EdgeInsets.symmetric` for balanced padding
- Follow Material Design 3 guidelines

### DON'T ❌
- Don't use `Colors.white`, `Colors.grey`, `Colors.red` directly
- Don't use `.withOpacity()` - use `.withValues(alpha:)` instead
- Don't use random spacing values - stick to multiples of 4
- Don't use border radius of 8 - use 12 or 16 instead
- Don't hardcode pixel values without constants
- Don't use magic numbers - define constants
- Don't forget to handle loading and error states
- Don't mix different border radius values in the same component
- Don't use heavy shadows everywhere - reserve for emphasis
- Don't ignore touch target sizes (minimum 48x48)

### Color Migration Examples
```dart
// ❌ OLD (Deprecated)
Colors.grey.withOpacity(0.5)
Colors.white
Colors.red
Colors.green

// ✅ NEW (Correct)
Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
Theme.of(context).colorScheme.surface
AppColors.error
AppColors.success
```

### Opacity Values Reference
```dart
.withValues(alpha: 1.0)   // 100% - Opaque
.withValues(alpha: 0.87)  // 87% - Primary text (high emphasis)
.withValues(alpha: 0.8)   // 80% - Secondary text emphasis
.withValues(alpha: 0.6)   // 60% - Secondary text (medium emphasis)
.withValues(alpha: 0.4)   // 40% - Disabled text, icons
.withValues(alpha: 0.3)   // 30% - Borders, light accents
.withValues(alpha: 0.2)   // 20% - Very light backgrounds
.withValues(alpha: 0.1)   // 10% - Subtle backgrounds, hover states
.withValues(alpha: 0.05)  // 5% - Very subtle shadows
```

---

## Component Library Reference

### Importing Required Packages
```dart
import 'package:flutter/material.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/style/app_text_styles.dart';
import 'package:app/core/style/app_theme.dart';
```

### Accessing Theme
```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;
final textTheme = theme.textTheme;
```

### Custom Widgets Location
- Authentication: `lib/features/auth/presentation/widgets/`
- Cart: `lib/features/cart/presentation/widgets/`
- Locations: `lib/features/locations/presentations/widgets/`
- Shop: `lib/features/shop/presentation/widgets/`
- Profile: `lib/features/profile/presentation/widgets/`
- Core: `lib/core/widgets/`

---

## Version History

**Version 2.0** (Current)
- Complete theme refactor to Dark Red & Gold
- Updated all components to Material Design 3
- Standardized border radius (12px/16px)
- Migrated to `.withValues(alpha:)` API
- Removed hardcoded colors across all features

**Version 1.0** (Legacy)
- Purple theme (#4D217B)
- Mixed border radius values
- Hardcoded colors throughout
- Old `.withOpacity()` API

---

## Questions or Updates?

For any clarifications or to propose updates to this design system, please consult with the design/development team. This document should be kept in sync with the actual implementation in the codebase.

**Last Updated:** 2025-11-10
