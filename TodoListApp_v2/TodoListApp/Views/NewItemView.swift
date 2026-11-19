import SwiftUI
import FirebaseFirestore

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Title", text: $viewModel.title)
                }

                Section("Due Date") {
                    if verticalSizeClass == .compact {
                        DatePicker("Due Date", selection: $viewModel.dueDate)
                            .datePickerStyle(.compact)
                    } else {
                        DatePicker("Due Date", selection: $viewModel.dueDate)
                            .datePickerStyle(.graphical)
                    }
                }

                Button("Save") {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { newItemPresented = false }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errMsg))
            }
        }
    }
}

#Preview {
    NewItemView(newItemPresented: .constant(true))
}
