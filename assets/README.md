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

## Mock Data

The app includes a "Use Mock Data" feature for testing without internet connectivity. This loads a sample JSON response from the WorldTime API that was captured during development.

### Mock Data Source
```json
{
  "utc_offset": "+01:00",
  "timezone": "Europe/Berlin",
  "day_of_week": 1,
  "day_of_year": 328,
  "datetime": "2025-11-24T15:18:22.915102+01:00",
  "utc_datetime": "2025-11-24T14:18:22.915102+00:00",
  "unixtime": 1763993902,
  "raw_offset": 3600,
  "week_number": 48,
  "dst": false,
  "abbreviation": "CET",
  "dst_offset": 0,
  "dst_from": null,
  "dst_until": null,
  "client_ip": "154.222.4.158"
}
```

### Usage
- Click the "Use Mock Data" button on the loading screen when API calls fail
- This will process the mock JSON as if it came from the WorldTime API
- Shows location as "Berlin (Mock)" to indicate it's test data
- Provides full app functionality without internet connection

### Purpose
- **Testing**: Verify app functionality without network dependency
- **Development**: Test UI changes without API limits
- **Demo**: Showcase app features when internet is unavailable

## Notes
- Images should be optimized for different screen sizes and densities
- Consider accessibility features (contrast, alternative descriptions)
- File size should be reasonable to avoid inflating app bundle size

## Attribution
[Add any attribution or licensing information for the images here if they are from external sources]