import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let backColor: Color
    var minimumHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
            Text(title)
                .font(.largeTitle)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: minimumHeight)
        .background(backColor, in: RoundedRectangle(cornerRadius: 20))
    }
}

// Shared layout for both authentication screens.
// Measure the container, not the physical device's screen.
struct AdaptiveAuthLayout<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let title: String
    let subtitle: String
    let color: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            let padding: CGFloat = horizontalSizeClass == .regular ? 32 : 16
            let availableWidth = max(0, geometry.size.width - padding * 2)
            let availableHeight = max(0, geometry.size.height - padding * 2)
            let columnsWidth = max(0, availableWidth - 24)
            let useColumns = verticalSizeClass == .compact ||
                (horizontalSizeClass == .regular && geometry.size.width >= 520)

            ScrollView {
                if useColumns {
                    // Like GeometryReaderView in the demo, use a share of the window width.
                    HStack(alignment: .center, spacing: 24) {
                        HeaderView(title: title, subtitle: subtitle, backColor: color,
                                   minimumHeight: availableHeight)
                            .frame(width: columnsWidth * 0.4)
                        form(minimumHeight: availableHeight)
                    }
                    .frame(maxWidth: .infinity, minHeight: availableHeight,
                           alignment: .center)
                } else {
                    VStack(spacing: 24) {
                        HeaderView(title: title, subtitle: subtitle, backColor: color)
                        form(minimumHeight: 0)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, minHeight: availableHeight,
                           alignment: .center)
                }
            }
            .padding(padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private func form(minimumHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            content()
                .frame(maxWidth: .infinity)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: max(0, minimumHeight - 40),
               alignment: .center)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "Remember", backColor: .pink)
}
