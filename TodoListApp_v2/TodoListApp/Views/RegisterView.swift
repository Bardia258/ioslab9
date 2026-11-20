import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()

    var body: some View {
        AdaptiveAuthLayout(title: "Register", subtitle: "Start organizing todos", color: .orange) {
            VStack(spacing: 16) {
                if !viewModel.errMsg.isEmpty {
                    Text(viewModel.errMsg)
                        .foregroundStyle(.red)
                }

                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()

                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)

                Button {
                    viewModel.register()
                } label: {
                    Text("Create Account").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { RegisterView() }
}

#Preview("iPhone portrait stacked", traits: .fixedLayout(width: 390, height: 844)) {
    NavigationStack { RegisterView() }
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("iPhone landscape", traits: .fixedLayout(width: 667, height: 375)) {
    NavigationStack { RegisterView() }
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
}
