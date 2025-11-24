# Assets Directory

This directory contains static assets used by the World Time App.

## Files

### Background Images
- `day.png` - Background image displayed during daytime (when current time is between 6 AM and 8 PM)
- `night.png` - Background image displayed during nighttime (when current time is before 6 AM or after 8 PM)

## Usage
These background images are dynamically loaded based on the current time of day:

```dart
String bgImage = data['isDaytime'] ? 'day.png' : 'night.png';
```

The images are applied as full-screen backgrounds using `DecorationImage` with `BoxFit.cover` for optimal scaling.

## Asset Configuration
These assets are configured in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/
```

## Notes
- Images should be optimized for different screen sizes and densities
- Consider accessibility features (contrast, alternative descriptions)
- File size should be reasonable to avoid inflating app bundle size

## Attribution
[Add any attribution or licensing information for the images here if they are from external sources]