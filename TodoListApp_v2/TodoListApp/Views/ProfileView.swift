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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let user: User
    let logout: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let padding: CGFloat = horizontalSizeClass == .regular ? 32 : 16
            let availableWidth = max(0, geometry.size.width - padding * 2)
            let availableHeight = max(0, geometry.size.height - padding * 2)
            let useColumns = geometry.size.width >= 520 &&
                (horizontalSizeClass == .regular || verticalSizeClass == .compact)

            ScrollView {
                if useColumns {
                    HStack(alignment: .top, spacing: 24) {
                        avatar(size: (availableWidth - 24) * 0.22,
                               minimumHeight: availableHeight)
                            .frame(width: (availableWidth - 24) * 0.35)
                        details(minimumHeight: availableHeight)
                    }
                } else {
                    VStack(spacing: 24) {
                        avatar(size: availableWidth * 0.35,
                               minimumHeight: availableHeight * 0.3)
                        details(minimumHeight: max(0, availableHeight * 0.7 - 24))
                    }
                }
            }
            .padding(padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }

    private func avatar(size: CGFloat, minimumHeight: CGFloat) -> some View {
        VStack {
            Spacer(minLength: 0)
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blue)
                .frame(width: size, height: size)
                .accessibilityHidden(true)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, minHeight: minimumHeight)
        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 20))
    }

    private func details(minimumHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            profileRow("Name", value: user.name)
            Divider()
            profileRow("Email", value: user.email)
            Divider()
            profileRow("Member since", value: Date(timeIntervalSince1970: user.joined)
                .formatted(date: .abbreviated, time: .shortened))
            Spacer(minLength: 24)
            Button(action: logout) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.red)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: minimumHeight, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 20))
    }

    private func profileRow(_ label: String, value: String) -> some View {
        // Same horizontal-first, vertical-fallback approach as ViewThatFitsView.
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 16) {
                Text(label).font(.headline).fixedSize()
                Spacer(minLength: 0)
                Text(value).fixedSize()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(label).font(.headline)
                Text(value).fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    .environment(\.horizontalSizeClass, .regular)
    .environment(\.verticalSizeClass, .regular)
}

#Preview("Small iPhone landscape", traits: .fixedLayout(width: 568, height: 320)) {
    NavigationStack {
        ProfileDetailsView(user: User(id: "preview", name: "Alex Morgan",
                                      email: "alex.morgan@example.com", joined: 0), logout: {})
            .navigationTitle("Profile")
    }
    .environment(\.horizontalSizeClass, .compact)
    .environment(\.verticalSizeClass, .compact)
}
