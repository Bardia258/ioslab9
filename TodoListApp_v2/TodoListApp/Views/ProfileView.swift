import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if let user = viewModel.user {
                    ProfileDetailsView(user: user) { viewModel.logout() }
                } else {
                    ProgressView("Loading Profile ...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear { viewModel.fetchUser() }
    }
}

// Keep the layout previewable without fetching a Firebase profile.
private struct ProfileDetailsView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let user: User
    let logout: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let short = verticalSizeClass == .compact || geometry.size.height < 450
            let wide = geometry.size.width >= 600 && !dynamicTypeSize.isAccessibilitySize
            let layout = wide
                ? AnyLayout(HStackLayout(alignment: .top, spacing: 24))
                : AnyLayout(VStackLayout(spacing: 24))

            ScrollView {
                layout {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.blue)
                        .frame(width: short ? 80 : 125, height: short ? 80 : 125)
                        .accessibilityHidden(true)
                    details
                        .frame(maxWidth: 440, alignment: .leading)
                }
                .frame(maxWidth: wide ? 700 : 440)
                .frame(maxWidth: .infinity,
                       minHeight: max(0, geometry.size.height - 40),
                       alignment: short ? .top : .center)
                .padding(20)
            }
        }
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 16) {
            profileRow("Name", value: user.name)
            profileRow("Email", value: user.email)
            profileRow("Member since", value: Date(timeIntervalSince1970: user.joined)
                .formatted(date: .abbreviated, time: .shortened))
            Button("Logout", action: logout)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func profileRow(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.headline)
            Text(value).fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileDetailsView(user: User(id: "preview", name: "Alex Morgan",
                                      email: "alex.morgan@example.com", joined: 0), logout: {})
            .navigationTitle("Profile")
    }
}

#Preview("Narrow iPad window, large text", traits: .fixedLayout(width: 375, height: 700)) {
    NavigationStack {
        ProfileDetailsView(user: User(id: "preview", name: "Alex Morgan with a long name",
                                      email: "alex.morgan.with.a.long.email@example.com", joined: 0), logout: {})
            .navigationTitle("Profile")
    }
    .environment(\.dynamicTypeSize, .accessibility3)
}

#Preview("iPad landscape", traits: .fixedLayout(width: 1024, height: 768)) {
    NavigationStack {
        ProfileDetailsView(user: User(id: "preview", name: "Alex Morgan",
                                      email: "alex.morgan@example.com", joined: 0), logout: {})
            .navigationTitle("Profile")
    }
}
