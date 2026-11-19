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
