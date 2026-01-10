# App Store Submission Checklist

## Before You Start

- [ ] Apple Developer Program membership ($99/year)
- [ ] Xcode installed with latest iOS SDK
- [ ] Physical iPhone for testing (Screen Time APIs don't work in simulator)

---

## 1. Apple Developer Portal Setup

### App ID & Provisioning
- [ ] Create App ID with your bundle identifier (if not already done)
- [ ] Enable App Groups capability
- [ ] Enable Family Controls capability
- [ ] Create provisioning profile for distribution

> **Note**: Family Controls is available to all developers since iOS 16. No special approval needed - if it works during development, it will work in production.

---

## 2. Xcode Project Setup

### Bundle Identifier
- [ ] Change from `YawningFace.blocker-last-push` to your identifier
- [ ] Update in both targets (main app + extension)
- [ ] Update App Groups identifier to match

### Display Name
- [ ] Change from "blocker_last_push" to "Pact" (or chosen name)
- [ ] Target → General → Display Name

### App Icon
- [ ] Create 1024x1024 PNG (see APP_ICON.md)
- [ ] Add to Assets.xcassets/AppIcon.appiconset
- [ ] Verify icon appears on device

### Version & Build
- [ ] Set Version to 1.0.0
- [ ] Set Build to 1
- [ ] Increment build for each upload

---

## 3. Code Cleanup

### ProfileView TODOs
- [ ] Either implement or remove these buttons:
  - [ ] Export My Data
  - [ ] Help & FAQ
  - [ ] Contact Support

### Testing
- [ ] Test full onboarding flow
- [ ] Test app blocking works
- [ ] Test schedule creation
- [ ] Test strict mode challenge
- [ ] Test on multiple iOS versions (16, 17, 18)

---

## 4. App Store Connect Setup

### Create App
- [ ] Log in to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- [ ] My Apps → + → New App
- [ ] Select iOS platform
- [ ] Enter app name
- [ ] Select primary language
- [ ] Select bundle ID
- [ ] Enter SKU (any unique string)

### App Information
- [ ] Subtitle (30 chars)
- [ ] Category: Productivity
- [ ] Secondary category: Health & Fitness
- [ ] Content rights: "Does not contain third-party content"

### Pricing
- [ ] Price: Free
- [ ] Select availability (countries)

### Privacy
- [ ] Privacy Policy URL (host PRIVACY_POLICY.md somewhere)
- [ ] Data collection: Select "None" (we don't collect data)

### App Privacy Details
Answer the questionnaire:
- [ ] Contact Info: No
- [ ] Health & Fitness: No
- [ ] Financial Info: No
- [ ] Location: No
- [ ] Sensitive Info: No
- [ ] Contacts: No
- [ ] User Content: No
- [ ] Browsing History: No
- [ ] Search History: No
- [ ] Identifiers: No
- [ ] Purchases: No
- [ ] Usage Data: No
- [ ] Diagnostics: No

---

## 5. Prepare Submission

### Screenshots
- [ ] Take 6.7" screenshots (see screenshots/README.md)
- [ ] Take 6.5" screenshots
- [ ] Upload to App Store Connect

### App Preview (Optional)
- [ ] 15-30 second video showing app in action

### Metadata
- [ ] Description (from APP_STORE_LISTING.md)
- [ ] Keywords
- [ ] Support URL
- [ ] Marketing URL (optional)
- [ ] Version release notes

### Review Information
- [ ] Contact email
- [ ] Contact phone
- [ ] Review notes (from APP_STORE_LISTING.md)

### Age Rating
- [ ] Complete questionnaire (all "No" = 4+)

---

## 6. Build & Upload

### Archive
- [ ] Select "Any iOS Device" as destination
- [ ] Product → Archive
- [ ] Wait for archive to complete

### Upload
- [ ] In Organizer, select archive
- [ ] Click "Distribute App"
- [ ] Select "App Store Connect"
- [ ] Upload

### Processing
- [ ] Wait for build to process (10-30 minutes)
- [ ] Select build in App Store Connect

---

## 7. Submit for Review

- [ ] Fill in all required fields
- [ ] Add screenshots to all required sizes
- [ ] Submit for review
- [ ] Wait (typically 24-48 hours, sometimes longer)

---

## Post-Submission

### If Rejected
- [ ] Read rejection reason carefully
- [ ] Fix the issue
- [ ] Reply or submit new build
- [ ] Common reasons:
  - Guideline 2.1: App doesn't work as described
  - Guideline 4.2: Minimum functionality
  - Missing privacy policy
  - Non-functional buttons/features

### If Approved
- [ ] Celebrate! 🎉
- [ ] Set release date (immediate or scheduled)
- [ ] Prepare social media announcement
- [ ] Monitor reviews and crashes

---

## Timeline Estimate

| Task | Time |
|------|------|
| App icon & screenshots | 1-2 days |
| App Store Connect setup | 1-2 hours |
| Build & upload | 30 minutes |
| Review process | 1-3 days |

**Total: ~2-5 days** (mostly waiting for App Review)

---

## Helpful Links

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Family Controls Documentation](https://developer.apple.com/documentation/familycontrols)
