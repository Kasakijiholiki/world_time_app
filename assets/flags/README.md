# Required Flag Images

This directory should contain the flag images referenced by the WorldTime app for location selection.

## Required Images

### Country Flags
The following flag images are used in the location selection screen:

- `egypt.png` - Flag of Egypt (for Cairo location)
- `greece.png` - Flag of Greece (for Athens location)  
- `indonesia.png` - Flag of Indonesia (for Jakarta location)
- `kenya.png` - Flag of Kenya (for Nairobi location)
- `south_korea.png` - Flag of South Korea (for Seoul location)
- `uk.png` - Flag of United Kingdom (for London location)
- `usa.png` - Flag of United States (for Chicago and New York locations)

### Background Images
Located in the parent `assets/` directory:
- `day.png` - Daytime background image
- `night.png` - Nighttime background image

## Usage

These images are loaded dynamically in the location selection screen:

```dart
CircleAvatar(
  backgroundImage: AssetImage('assets/${locations[index].flag}'),
)
```

## Image Specifications

- **Format**: PNG (recommended for flags with transparent backgrounds)
- **Size**: 64x64px or similar small square dimensions
- **Optimization**: Consider file size for app bundle optimization
- **Transparency**: Use transparent backgrounds where appropriate

## Sources

You can obtain flag images from:
- Wikimedia Commons (public domain flags)
- Flagpedia.net
- Local flag image assets
- Icon libraries with country flags

## Note

Without these flag images, the location selection will show empty circles instead of country flags. Add the images to enable the full visual experience of the WorldTime app.