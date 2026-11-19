# Todo List — Adaptive UI Lab

## Objective

Adapt the completed Week 09 Firebase Todo List app to work on iPhones in portrait and landscape and on iPads. The existing Firebase authentication, Firestore CRUD, MVVM models, and ViewModels are retained. The layout uses the Adaptive UI lesson's stacks, size classes, GeometryReader, flexible frames, scrollable content, and semantic fonts.

## What was implemented

| Screen / file | Changes |
| --- | --- |
| `HeaderView.swift` | Removed the oversized screen-width-based rotated header and negative offset. The replacement header sizes itself to its container. Added a reusable `AdaptiveAuthLayout` for login and registration. |
| `LoginView.swift` | Uses the shared adaptive layout, scrollable content, flexible form widths, and `NavigationStack` for single-column navigation. Keeps login and registration navigation. |
| `RegisterView.swift` | Uses the same shared layout without a fixed vertical offset. All inputs and the create account button remain accessible by scrolling. |
| `TodoListView.swift` | Uses `NavigationStack` and a centered list with a maximum width of 760 points. Keeps the Firestore query, add sheet and swipe-to-delete. |
| `NewItemView.swift` | Uses a scrollable `Form`, navigation title and cancel button instead of the large fixed top padding. Uses a compact date picker in compact-height environments and a graphical picker otherwise. The form is capped at 600 points. |
| `ProfileView.swift` | Uses a vertical layout on narrow portrait screens and side-by-side avatar/details for regular-width or compact-height layouts. Scrollable content, wrapping text and a smaller avatar in compact height help prevent clipping. |
| `SingleItemView.swift` | Long titles and dates can wrap; the completion button has a minimum 44-point target and an accessibility label. |
| `project.pbxproj` | Enabled portrait, upside-down portrait, landscape left and landscape right in both Debug and Release for iPhone and iPad. iOS/device restrictions still apply (some iPhones do not support upside-down portrait). |

## How the adaptive layout works

### 1. GeometryReader and size classes

`AdaptiveAuthLayout` reads its actual available width rather than assuming the physical screen size. A width of at least 700 points, or a compact vertical size class with at least 520 points of width, selects an `HStack` with the header beside the fields. Otherwise, a `VStack` puts the header above the fields. A `ScrollView` keeps the fields and buttons reachable when the keyboard or landscape orientation reduces available height.

```swift
@Environment(\.verticalSizeClass) private var verticalSizeClass

GeometryReader { geometry in
    let wide = geometry.size.width >= 700 ||
        (verticalSizeClass == .compact && geometry.size.width >= 520)
    // HStack for wide containers; VStack otherwise.
}
```

The size thresholds are layout choices for this lab, not fixed definitions of iPhone or iPad. Narrow iPad windows can also use the stacked layout.

### 2. Flexible sizing and navigation

`.frame(maxWidth: ...)` limits the width of forms and lists on larger screens; `.frame(maxWidth: .infinity)` centers content or allows it to fill available width. Semantic fonts such as `.largeTitle` and `.headline` support Dynamic Type. `NavigationStack` avoids the default split-view behavior of the original `NavigationView` on iPad. The authenticated `TabView` remains unchanged and adapts natively to the device.

### 3. Compact landscape forms

`NewItemView` reads `verticalSizeClass` to choose between `.compact` and `.graphical` date picker styles. The form scrolls if its content exceeds the available space. This also handles sheets with limited height. Profile uses horizontal and vertical size classes to select a layout.

## Run in Xcode

1. Unzip this archive and open `TodoListApp.xcodeproj` in Xcode 26 or later (the original project targets iOS 26.0).
2. Select the **TodoListApp** target, then **Signing & Capabilities**. If necessary, select your team and change the bundle identifier to your own unique identifier. The original identifier is `ca.medhat.TodoListApp`.
3. Open the Firebase console at https://console.firebase.google.com/ and create or select your own Firebase project.
4. Register an iOS app using the exact bundle identifier shown in Xcode.
5. Download your own `GoogleService-Info.plist` and add it to `TodoListApp/Others/` in the Xcode project. Ensure it belongs to the app target (the source uses an automatically synchronized project folder). Do not rename the file or put a second copy in the target.
6. Enable **Authentication → Sign-in method → Email/Password** and create a **Cloud Firestore** database. Configure rules permitting authenticated users to access only their own profile and todos. For example, the following rules match the existing app's data paths:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /todos/{todoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

7. Let Xcode resolve the original Firebase Swift package dependencies. Select an iPhone or iPad simulator and press **Cmd + R**.

**Important:** No real Firebase plist was supplied in the original archive, so none is included in this solution. The app's original `FirebaseApp.configure()` requires your valid configuration before launch. The sample rules above are not deployed automatically.

## Manual verification checklist

Run the following on an iPhone (portrait, landscape left, landscape right) and iPad (portrait and both landscape directions). Try a small iPhone and a resizable iPad window as well if available.

- [ ] Login header and fields fit the screen; scroll with the keyboard visible.
- [ ] Register screen is reachable; all fields and the create account button remain accessible after rotation.
- [ ] Create an account, sign in, and verify the Home/Profile/Logout tabs are visible or accessible.
- [ ] Add a todo using the plus button, enter a title and date, and rotate while editing. Save and verify the todo appears.
- [ ] Try saving an empty title and verify the original validation alert appears.
- [ ] Mark a todo complete/incomplete; swipe to delete it.
- [ ] Verify a long title wraps and the profile information remains readable.
- [ ] Log out and verify the app returns to login.
- [ ] Verify state and entered text survive rotation; try a larger Dynamic Type setting.

## Validation performed

All Swift files passed `swiftc -frontend -parse` (syntax-only validation). The project settings were updated for both build configurations. Full compilation, iOS simulator layout checks and live Firebase verification require macOS/Xcode and your Firebase configuration; they have not been performed here. The original Firebase and MVVM logic, including its existing error-handling behavior, was intentionally left unchanged because this assignment is about adaptive UI.
