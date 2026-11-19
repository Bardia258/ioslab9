import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                if let user = viewModel.user {
                    if horizontalSizeClass == .regular || verticalSizeClass == .compact {
                        HStack(alignment: .top, spacing: 24) {
                            avatar
                            details(user: user)
                        }
                        .frame(maxWidth: 700)
                        .padding()
                        .frame(maxWidth: .infinity)
                    } else {
                        VStack(spacing: 24) {
                            avatar
                            details(user: user)
                        }
                        .frame(maxWidth: 420)
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    Text("Loading Profile ...")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear { viewModel.fetchUser() }
    }

    private var avatar: some View {
        Image(systemName: "person.circle")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.blue)
            .frame(width: verticalSizeClass == .compact ? 80 : 125,
                   height: verticalSizeClass == .compact ? 80 : 125)
            .accessibilityHidden(true)
    }

    private func details(user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            profileRow("Name", value: user.name)
            profileRow("Email", value: user.email)
            profileRow("Member since", value: Date(timeIntervalSince1970: user.joined)
                .formatted(date: .abbreviated, time: .shortened))
            Button("Logout") { viewModel.logout() }
                .buttonStyle(.bordered)
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
    ProfileView()
}
