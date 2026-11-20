import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let useCompactPicker = verticalSizeClass == .compact ||
                    geometry.size.height < 600 || geometry.size.width < 360 ||
                    dynamicTypeSize.isAccessibilitySize

                Form {
                    Section("Task") {
                        TextField("Title", text: $viewModel.title, axis: .vertical)
                            .lineLimit(1...3)
                    }

                    Section("Due Date") {
                        if useCompactPicker {
                            // Separate controls fit narrow windows and larger text.
                            DatePicker("Due Date", selection: $viewModel.dueDate,
                                       displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                            DatePicker("Due Time", selection: $viewModel.dueDate,
                                       displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        } else {
                            DatePicker("Due Date", selection: $viewModel.dueDate)
                                .datePickerStyle(.graphical)
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { newItemPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .bold()
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errMsg))
            }
        }
    }

    private func save() {
        if viewModel.canSave {
            viewModel.save()
            newItemPresented = false
        } else {
            viewModel.showAlert = true
        }
    }
}

#Preview {
    NewItemView(newItemPresented: .constant(true))
}

#Preview("iPhone landscape", traits: .fixedLayout(width: 568, height: 320)) {
    NewItemView(newItemPresented: .constant(true))
        .environment(\.verticalSizeClass, .compact)
}

#Preview("Narrow window, large text", traits: .fixedLayout(width: 320, height: 568)) {
    NewItemView(newItemPresented: .constant(true))
        .environment(\.dynamicTypeSize, .accessibility3)
}

#Preview("iPad landscape", traits: .fixedLayout(width: 1024, height: 768)) {
    NewItemView(newItemPresented: .constant(true))
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
}
