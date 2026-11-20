import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()

    var body: some View {
        NavigationStack {
            AdaptiveAuthLayout(title: "Todo List", subtitle: "Remember", color: .pink) {
                VStack(spacing: 16) {
                    if !viewModel.errMsg.isEmpty {
                        Text(viewModel.errMsg)
                            .foregroundStyle(.red)
                    }

                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        viewModel.login()
                    } label: {
                        Text("Log In").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    VStack(spacing: 8) {
                        Text("New user?")
                        NavigationLink("Create an account") {
                            RegisterView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

#Preview("iPhone portrait stacked", traits: .fixedLayout(width: 390, height: 844)) {
    LoginView()
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("Small iPhone landscape", traits: .fixedLayout(width: 568, height: 320)) {
    LoginView()
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
}

#Preview("Narrow iPhone landscape", traits: .fixedLayout(width: 500, height: 280)) {
    LoginView()
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
}

#Preview("iPad landscape", traits: .fixedLayout(width: 1024, height: 768)) {
    LoginView()
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("iPad portrait", traits: .fixedLayout(width: 768, height: 1024)) {
    LoginView()
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
}

#Preview("Large text", traits: .fixedLayout(width: 375, height: 667)) {
    LoginView()
        .environment(\.dynamicTypeSize, .accessibility3)
}
