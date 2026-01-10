# App Icon Guide

## Requirements

- **Size**: 1024 x 1024 pixels
- **Format**: PNG (no transparency for iOS)
- **Shape**: Square (iOS automatically applies rounded corners)

## Design Direction

### Option 1: Shield Concept
A shield icon representing protection from distractions.
- Dark background (#111926 - app's background color)
- Yellow shield outline or fill (#FACC16 - app's accent color)
- Simple, bold, recognizable at small sizes

### Option 2: Lock/Time Concept
Combining a lock with a clock to represent scheduled blocking.
- Clock face with a lock overlay
- Yellow accent on dark background

### Option 3: Abstract/Minimal
Simple geometric shape suggesting "blocking" or "focus".
- Circle with a slash (universal "no" symbol)
- Minimalist approach

### Option 4: Hand/Stop Concept
A hand or stop symbol representing blocking.
- Yellow hand on dark background
- Clean, direct messaging

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Background | #111926 | Dark base |
| Accent | #FACC16 | Yellow highlight |
| Card | #1F2937 | Secondary dark |
| White | #FFFFFF | Contrast elements |

## Tools to Create

### Free Options
- **Figma** (figma.com) - Free, web-based
- **Canva** (canva.com) - Free tier available
- **GIMP** - Free, open-source Photoshop alternative
- **Photopea** (photopea.com) - Free, web-based Photoshop clone

### Paid Options
- Adobe Illustrator
- Sketch
- Affinity Designer

### AI Options
- Midjourney
- DALL-E
- Stable Diffusion

## Quick Figma Tutorial

1. Create new file (1024x1024)
2. Add rectangle, fill with #111926
3. Add shield shape (use shield icon from SF Symbols as reference)
4. Fill shield with #FACC16
5. Export as PNG

## Adding to Xcode

1. Open `YawningFace/Assets.xcassets/AppIcon.appiconset/`
2. Drag your 1024x1024 PNG into Xcode
3. Xcode will use it for all sizes automatically (iOS 17+)

Or manually update `Contents.json`:
```json
{
  "images" : [
    {
      "filename" : "AppIcon.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

## Checklist

- [ ] Create 1024x1024 PNG
- [ ] Ensure no transparency
- [ ] Test at small sizes (29pt, 40pt, 60pt)
- [ ] Check it looks good on light AND dark home screens
- [ ] Add to Assets.xcassets
- [ ] Build and verify on device
