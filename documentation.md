# Block iPhone

An iOS app that blocks distracting apps using Apple's Screen Time API. Schedule blocking periods and stay focused.

## Features

- Block selected apps during scheduled time periods
- Uses Apple's native Screen Time / Family Controls framework
- Blocking persists even if the app is force-quit
- Streak tracking for motivation

## Before You Begin

**Important**: You must replace the placeholder bundle identifiers with your own:

| Replace | With |
|---------|------|
| `YawningFace.blocker-last-push` | `YourTeam.your-app-name` |
| `group.YawningFace.blocker-last-push` | `group.YourTeam.your-app-name` |

**Files to update:**
- `blocker_last_push/blocker_last_push.entitlements`
- `DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements`
- `blocker_last_push/BlockerModel.swift` (line 18)
- `DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.swift` (line 9)

---

## Requirements

- Xcode 15+
- iOS 16+
- Apple Developer account with Family Controls capability
- Physical iOS device (Screen Time APIs don't work in Simulator)

---

## Setup

### Step 1: Add the DeviceActivityMonitor Extension Target

1. Open `blocker_last_push.xcodeproj` in Xcode
2. Go to **File > New > Target**
3. Search for **"Device Activity Monitor Extension"**
4. Select it and click **Next**
5. Configure:
   - **Product Name**: `DeviceActivityMonitorExtension`
   - **Bundle Identifier**: `YawningFace.blocker-last-push.DeviceActivityMonitorExtension`
   - **Team**: Select your team
   - **Embed in Application**: `blocker_last_push`
6. Click **Finish**
7. If prompted to activate the scheme, click **Activate**

**Important**: After Xcode creates the target, **delete the auto-generated Swift file** (usually named `DeviceActivityMonitorExtension.swift` in a new group) and use the one already in the `DeviceActivityMonitorExtension` folder.

To use the existing files:
1. Delete the auto-generated files in the new target group
2. Right-click on the `DeviceActivityMonitorExtension` target in the Project Navigator
3. Select **Add Files to "blocker_last_push"**
4. Navigate to and select all files in the `DeviceActivityMonitorExtension` folder
5. Ensure **"DeviceActivityMonitorExtension"** target is checked
6. Click **Add**

---

### Step 2: Configure App Groups (Both Targets)

### Main App Target

1. Select the **blocker_last_push** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Click the **+** under App Groups
6. Enter: `group.YawningFace.blocker-last-push`

### Extension Target

1. Select the **DeviceActivityMonitorExtension** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Add the same group: `group.YawningFace.blocker-last-push`

---

### Step 3: Configure Family Controls (Both Targets)

### Main App Target

1. Select the **blocker_last_push** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **Family Controls**

### Extension Target

1. Select the **DeviceActivityMonitorExtension** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **Family Controls**

---

### Step 4: Set Entitlements Files

Xcode may auto-generate entitlements files. You can either:

**Option A**: Let Xcode manage them (it will add the capabilities automatically)

**Option B**: Use the provided entitlements files:

### Main App
1. Select **blocker_last_push** target
2. Go to **Build Settings**
3. Search for "Code Signing Entitlements"
4. Set to: `blocker_last_push/blocker_last_push.entitlements`

### Extension
1. Select **DeviceActivityMonitorExtension** target
2. Go to **Build Settings**
3. Search for "Code Signing Entitlements"
4. Set to: `DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements`

---

### Step 5: Configure Extension Info.plist

Ensure the extension's Info.plist contains:

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.deviceactivitymonitor</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).DeviceActivityMonitorExtension</string>
</dict>
```

The provided `DeviceActivityMonitorExtension/Info.plist` already has this configured.

---

### Step 6: Verify Target Membership

Ensure files are in the correct targets:

| File | Main App | Extension |
|------|----------|-----------|
| `blocker_last_pushApp.swift` | ✓ | |
| `ContentView.swift` | ✓ | |
| `BlockerModel.swift` | ✓ | |
| `ScheduleManager.swift` | ✓ | |
| `DeviceActivityMonitorExtension.swift` | | ✓ |

To check/modify target membership:
1. Select a file in Project Navigator
2. Open File Inspector (right panel)
3. Check the appropriate targets under "Target Membership"

---

### Step 7: Build and Run

1. Connect a physical iOS device
2. Select your device as the run destination
3. Build and run (Cmd + R)

**Note**: The app requires a physical device. Screen Time APIs do not work in the iOS Simulator.

---

## Troubleshooting

### "Family Controls capability requires..."
- Ensure your Apple Developer account has the Family Controls capability enabled
- Go to developer.apple.com > Certificates, Identifiers & Profiles
- Edit your App ID and enable Family Controls

### Extension not triggering
- Verify the extension is embedded in the main app (check Build Phases > Embed App Extensions)
- Ensure both targets have matching App Group identifiers
- Check that the extension's principal class matches the class name

### Authorization fails
- Screen Time must be enabled on the device (Settings > Screen Time)
- The app must be signed with a provisioning profile that includes Family Controls

### Blocking not persisting
- Verify App Groups are configured identically on both targets
- Check that the group identifier matches exactly: `group.YawningFace.blocker-last-push`

---

## Known Platform Limitations

These are documented issues with Apple's Screen Time APIs that cannot be fixed at the app level:

### iOS 17+ Reliability Issues

Multiple developers report that `intervalDidStart` and `intervalDidEnd` callbacks don't fire reliably on iOS 17+. This appears to be an Apple bug.

**Workarounds:**
- Restart the device
- Re-grant Screen Time permissions (Settings > Screen Time)
- Disable Low Power Mode
- Wait (the system sometimes recovers after minutes/hours)

**References:**
- [Apple Forums: Screen Time API unreliable](https://developer.apple.com/forums/thread/750623)
- [Apple Forums: DeviceActivityMonitor unreliable](https://developer.apple.com/forums/thread/743007)

### 15-Minute Minimum Interval

DeviceActivitySchedule has an undocumented 15-minute minimum interval requirement. Schedules shorter than 15 minutes may not trigger callbacks reliably. Our implementation uses 3-hour and 9-hour schedules, so this doesn't affect us.

### Extension Memory Limit

The DeviceActivityMonitor extension has a hard 5MB memory limit. Exceeding this causes Jetsam crashes. Keep extension code minimal.

### Debug vs Release Behavior

The APIs may behave differently when connected to Xcode vs running independently. Always test in release mode disconnected from Xcode.

### Shields Persist After Extension Exits

Once `ManagedSettingsStore.shield.applications` is set, the shield persists even after the extension process terminates. This is by design and is what enables blocking to work when the app is force-quit.

---

## Architecture Notes

### Why the Main App Doesn't Touch ManagedSettingsStore

Per Apple's design, the main app should only:
- Request authorization
- Let user select apps
- Register/unregister schedules

The **extension** is solely responsible for:
- Applying shields (`store.shield.applications = tokens`)
- Removing shields (`store.clearAllSettings()`)

This ensures shields remain active even if the user opens the main app during blocking hours.

### The Reset Button Exception

The "Reset Blocking" button in the app intentionally clears `ManagedSettingsStore`. This is for manual recovery if blocking gets stuck. It's a deliberate user action, not automatic behavior.

---

## License

MIT License - see [LICENSE](LICENSE) for details.
