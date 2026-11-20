# Todo List — Adaptive UI Lab

## Objective

Adapt the completed Week 09 Firebase Todo List app to work on iPhones in portrait and landscape and on iPads. The existing Firebase authentication, Firestore CRUD, MVVM models, and ViewModels are retained. The layout uses the Adaptive UI lesson's stacks, size classes, GeometryReader, flexible frames, scrollable content, and semantic fonts.

## What was implemented

| Screen / file | Changes |
| --- | --- |
| `HeaderView.swift` | Container-based `AdaptiveAuthLayout` switches between columns and a stack without replacing the fields. Centers content when space permits, scrolls in short windows or above the keyboard, and stacks at accessibility text sizes. Header text wraps. |
| `LoginView.swift` | Uses the shared adaptive layout, scrollable content, flexible form widths, and `NavigationStack` for single-column navigation. Keeps login and registration navigation. |
| `RegisterView.swift` | Uses the same shared layout without a fixed vertical offset. All inputs and the create account button remain accessible by scrolling. |
| `TodoListView.swift` | Uses `NavigationStack` and a centered list with a maximum width of 760 points. The add sheet uses form sizing on iPad, and the add button has an accessibility label. Keeps the Firestore query and swipe-to-delete. |
| `NewItemView.swift` | Scrollable `Form` capped at 600 points, with Save and Cancel in the navigation bar. Long titles can use up to three visible lines. Separate compact date/time controls fit short or narrow windows and accessibility text sizes; larger containers use a graphical picker. |
| `ProfileView.swift` | Measures the available container for stacked or side-by-side avatar/details, and uses a stack at accessibility text sizes. Scrollable, width-limited content, wrapping text and a smaller avatar in short windows help prevent clipping. Profile layout previews use sample data without a Firebase request. |
| `SingleItemView.swift` | Long titles and dates can wrap using the available row width; the completion button stays at the top with a minimum 44-point target and an accessibility label. |
| `project.pbxproj` | Already enables portrait, upside-down portrait, landscape left and landscape right in both Debug and Release for iPhone and iPad. iOS/device restrictions still apply (some iPhones do not support upside-down portrait). |

## How the adaptive layout works

### 1. GeometryReader and size classes

`AdaptiveAuthLayout` reads its actual available width and height rather than assuming the physical screen size. A width of at least 700 points, or a short container with at least 600 points of width, places the header beside the fields. Otherwise, it puts the header above the fields. Accessibility text sizes always use a stack. A `ScrollView` keeps the fields and buttons reachable when the keyboard or landscape orientation reduces available height; dragging can dismiss the keyboard interactively.

```swift
@Environment(\.verticalSizeClass) private var verticalSizeClass
@Environment(\.dynamicTypeSize) private var dynamicTypeSize

GeometryReader { geometry in
    let short = verticalSizeClass == .compact || geometry.size.height < 450
    let wide = !dynamicTypeSize.isAccessibilitySize &&
        (geometry.size.width >= 700 || (short && geometry.size.width >= 600))
    let layout = wide
        ? AnyLayout(HStackLayout(alignment: .center, spacing: 24))
        : AnyLayout(VStackLayout(spacing: 24))
    // Use layout { ... } for the same header and fields in either arrangement.
}
```

The size thresholds are layout choices for this lab, not fixed definitions of iPhone or iPad. Narrow iPad windows can also use the stacked layout. [Apple's `AnyLayout`](https://developer.apple.com/documentation/swiftui/anylayout) preserves subview identity when the container changes, keeping the same form fields during rotation.

### 2. Flexible sizing and navigation

`.frame(maxWidth: ...)` limits the width of forms and lists on larger screens; `.frame(maxWidth: .infinity)` centers content or allows it to fill available width. Semantic fonts such as `.largeTitle` and `.headline` support Dynamic Type. `NavigationStack` avoids the default split-view behavior of the original `NavigationView` on iPad. The authenticated `TabView` remains unchanged and adapts natively to the device.

### 3. Compact landscape forms

`NewItemView` uses compact date/time pickers when the vertical size class is compact, the available height is below 600 points, the width is below 360 points, or the text size is an accessibility size. Otherwise, it uses a graphical picker. The form scrolls if its content exceeds the available space. Save and Cancel stay in the navigation bar. The sheet requests [form presentation sizing](https://developer.apple.com/documentation/swiftui/presentationsizing/form) for an appropriate width on iPad.

Profile places its avatar beside the details only when the container is at least 600 points wide and text is not at an accessibility size. Its avatar shrinks when height is limited, including resized iPad windows whose vertical size class remains regular.

Named Xcode previews cover small iPhone landscape, iPad landscape, narrow windows and accessibility text sizes in the login, registration, profile and new-item view files.

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
- [ ] Resize the add-item sheet or iPad window; verify date/time controls fit and Save/Cancel stay reachable with the keyboard open.
- [ ] Try saving an empty title and verify the original validation alert appears.
- [ ] Mark a todo complete/incomplete; swipe to delete it.
- [ ] Verify a long title wraps and the profile information remains readable.
- [ ] Log out and verify the app returns to login.
- [ ] Verify state and entered text survive rotation; try a larger Dynamic Type setting.
- [ ] At an accessibility text size, verify authentication and profile use stacked layouts and long text scrolls without clipping.

## Validation performed

Source review and `git diff --check` were performed. The existing device-family and orientation settings were checked for both build configurations. This Windows environment has neither Swift nor Xcode, so the updated Swift files have not been compiled or run in an iOS simulator. Full compilation, device layout checks and live Firebase verification require macOS/Xcode and your Firebase configuration. The Firebase and MVVM logic, including its existing error-handling behavior, remains unchanged because this assignment is about adaptive UI.
