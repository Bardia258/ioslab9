# Todo List — Adaptive UI Lab

## Objective

Adapt the completed Week 09 Firebase Todo List app to work on iPhones in portrait and landscape and on iPads. The UI follows the supplied `adaptive_UI (1).docx` and `AdaptiveUIDemo (1).zip`: stacks and spacers, compact/regular size classes, GeometryReader, flexible frames, scrollable content and ViewThatFits. The existing Firebase authentication, Firestore operations, MVVM models and ViewModels are retained.

## What was implemented

| Screen / file | Changes |
| --- | --- |
| `HeaderView.swift` | `AdaptiveAuthLayout` uses an `HStack` on wider iPad/landscape windows and a `VStack` on narrow windows. GeometryReader sizes the panels as proportions of the available window, with no fixed maximum content width. Spacers distribute the form vertically. The header hides its decorative icon and subtitle at compact height, as the lesson hides secondary content in landscape. |
| `LoginView.swift` | Uses the shared adaptive layout, scrollable content, flexible form widths, and `NavigationStack` for single-column navigation. Keeps login and registration navigation. |
| `RegisterView.swift` | Uses the same shared layout without a fixed vertical offset. All inputs and the create account button remain accessible by scrolling. |
| `ContentView.swift` | The authenticated TabView fills its container directly. |
| `TodoListView.swift` | The list fills the available width and height. Removed the 760-point limit and the extra enclosing stack. Keeps the Firestore query, add-item sheet, completion controls and swipe-to-delete. |
| `NewItemView.swift` | Scrollable Form fills its system-provided sheet, with no 600-point content cap or custom sheet sizing. Save and Cancel remain in the navigation bar. Long titles can use up to three visible lines. Separate compact date/time controls fit short or narrow windows and accessibility text sizes; larger containers use a graphical picker. |
| `ProfileView.swift` | GeometryReader and size classes choose HStack/VStack panels that use the available window width and height. The avatar scales with container width. ViewThatFits tries each label/value row horizontally, then falls back to wrapping vertical text. Profile layout previews use sample data without a Firebase request. |
| `SingleItemView.swift` | Long titles and dates can wrap using the available row width; the completion button stays at the top with a minimum 44-point target and an accessibility label. |
| `project.pbxproj` | Already enables portrait, upside-down portrait, landscape left and landscape right in both Debug and Release for iPhone and iPad. iOS/device restrictions still apply (some iPhones do not support upside-down portrait). |

## How the adaptive layout works

### 1. GeometryReader and size classes

`AdaptiveAuthLayout` and the profile screen read their available width and height rather than assuming the physical screen size. Following the demo's adaptive form, they check compact/regular size classes. When the horizontal class is regular or the vertical class is compact, a window at least 520 points wide uses an HStack. Narrower windows use a VStack. A ScrollView keeps content reachable when the keyboard, large text or rotation reduces the space.

```swift
@Environment(\.horizontalSizeClass) private var horizontalSizeClass
@Environment(\.verticalSizeClass) private var verticalSizeClass

GeometryReader { geometry in
    let useColumns = geometry.size.width >= 520 &&
        (horizontalSizeClass == .regular || verticalSizeClass == .compact)
    // HStack for columns, VStack otherwise.
    // Panel widths and minimum heights come from geometry.size.
}
```

The 520-point threshold is a layout choice to leave usable room for both columns. Narrow iPad windows use the stacked arrangement. Login and registration values remain in their existing StateObject view models above the conditional layout, so the entered text survives rearrangement; keyboard focus should be checked on a device when switching between stack types.

### 2. Flexible sizing and navigation

The earlier fixed maximum widths of 420–800 points left broad unused margins on iPad. These caps have been removed. Like the demo's GeometryReader example, the authentication header and profile avatar use a share of the available width. Flexible frames fill the rest of the window, with 16-point padding in compact width and 32-point padding in regular width.

On wide layouts, both panels use at least the available viewport height. On stacked layouts, the header uses at least 30% and the form uses the remaining height after spacing. These are minimum heights, so larger text can grow and scroll. Spacers center the authentication fields and place the profile logout control below its details. Semantic fonts support Dynamic Type, and leading/trailing alignment follows the layout direction.

The task list fills its tab, and the new-item Form fills its sheet. The app keeps its existing TabView and NavigationStack navigation because it has no separate selected-item detail screen requiring the demo's NavigationSplitView.

### 3. Compact landscape forms

`NewItemView` uses compact date/time pickers when the vertical size class is compact, the available height is below 600 points, the width is below 360 points, or the text size is an accessibility size. Otherwise, it uses a graphical picker. The form scrolls if its content exceeds the available space. Save and Cancel stay in the navigation bar, and the sheet uses normal system sizing.

Profile uses the same size-class/width rule as authentication. Each profile row follows the supplied ViewThatFits example: an HStack first, then a VStack if the full label and value cannot fit side by side. Long names, email addresses and larger text can therefore wrap.

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
- [ ] On iPad, authentication and profile panels span the window with normal outer padding; the task list has no narrow centered column.
- [ ] Register screen is reachable; all fields and the create account button remain accessible after rotation.
- [ ] Create an account, sign in, and verify the Home/Profile/Logout tabs are visible or accessible.
- [ ] Add a todo using the plus button, enter a title and date, and rotate while editing. Save and verify the todo appears.
- [ ] Resize the add-item sheet or iPad window; verify date/time controls fit and Save/Cancel stay reachable with the keyboard open.
- [ ] Try saving an empty title and verify the original validation alert appears.
- [ ] Mark a todo complete/incomplete; swipe to delete it.
- [ ] Verify a long title wraps and the profile information remains readable.
- [ ] Log out and verify the app returns to login.
- [ ] Verify state and entered text survive rotation; try a larger Dynamic Type setting.
- [ ] At an accessibility text size, verify profile rows fall back to vertical text and all forms scroll without clipping.

## Validation performed

Source review and `git diff --check` were performed. The existing device-family and orientation settings were checked for both build configurations. This Windows environment has neither Swift nor Xcode, so the updated Swift files have not been compiled or run in an iOS simulator. Full compilation, device layout checks and live Firebase verification require macOS/Xcode and your Firebase configuration. The Firebase and MVVM logic, including its existing error-handling behavior, remains unchanged because this assignment is about adaptive UI.
