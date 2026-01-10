# App Store Screenshots Guide

## Required Sizes

You need screenshots for these device sizes:

| Device | Resolution | Required |
|--------|------------|----------|
| iPhone 6.7" (iPhone 15 Pro Max, 16 Pro Max) | 1290 x 2796 | Yes |
| iPhone 6.5" (iPhone 11 Pro Max, XS Max) | 1242 x 2688 | Yes |
| iPhone 5.5" (iPhone 8 Plus) | 1242 x 2208 | Optional |
| iPad Pro 12.9" | 2048 x 2732 | If supporting iPad |

## Screenshots to Capture (6-10 recommended)

### 1. Onboarding - Welcome
- Show the first onboarding screen
- Highlights: App logo, "Take back your focus" tagline
- File: `01_welcome.png`

### 2. Onboarding - How it Works
- Show the 3-step explanation
- Highlights: Simple process (choose apps → set schedule → stay focused)
- File: `02_how_it_works.png`

### 3. Home Screen - Active Blocking
- Show the home screen with blocking active
- Highlights: 😎 emoji, "Blocking Active" card
- File: `03_home_active.png`

### 4. App Selection
- Show the FamilyActivityPicker with apps selected
- Highlights: Native Apple UI for app selection
- File: `04_app_selection.png`

### 5. Schedule Setup
- Show the ScheduleSheetView
- Highlights: Time pickers, day selection, multiple periods
- File: `05_schedule_setup.png`

### 6. Profile - Streak
- Show the profile with a good streak
- Highlights: Streak count, compliance ring, commitment stats
- File: `06_profile_streak.png`

### 7. Strict Mode Challenge (Optional)
- Show the StrictModeChallengeView
- Highlights: Friction to prevent giving up
- File: `07_strict_mode.png`

### 8. Blocked App Screen (Optional)
- Show what users see when trying to open a blocked app
- Highlights: Apple's native shield screen
- File: `08_blocked_screen.png`

## Tips for Great Screenshots

1. **Use a clean device state**
   - Full battery or hide battery %
   - Clean status bar (good signal, no VPN icons)
   - Use "Show Screenshots" in Xcode simulator

2. **Show realistic data**
   - Good streak numbers (12 days, not 0)
   - Multiple apps blocked
   - Realistic schedule times

3. **Consider adding marketing text**
   - Many apps add text overlays like "Block distracting apps"
   - Tools: Figma, Sketch, or App Screenshot Maker apps

4. **Dark mode looks great**
   - The app already uses dark theme
   - Stands out in App Store listings

## How to Capture

### Option 1: Simulator (limited - can't show Screen Time)
```bash
xcrun simctl io booted screenshot screenshot.png
```

### Option 2: Physical Device (recommended)
1. Connect iPhone to Mac
2. Open QuickTime Player
3. File → New Movie Recording
4. Select your iPhone as source
5. Screenshot the QuickTime window

### Option 3: Xcode
1. Run app on device
2. Debug → View Debugging → Take Screenshot

## Naming Convention

```
01_welcome_6.7.png
01_welcome_6.5.png
02_how_it_works_6.7.png
02_how_it_works_6.5.png
...
```
