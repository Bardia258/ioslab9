import SwiftUI

struct HeaderView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let title: String
    let subtitle: String
    let backColor: Color
    var minimumHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            if verticalSizeClass != .compact {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
            }
            Text(title)
                .font(.largeTitle)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            if verticalSizeClass != .compact {
                Text(subtitle)
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
            }
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
            let useColumns = geometry.size.width >= 520 &&
                (horizontalSizeClass == .regular || verticalSizeClass == .compact)

            ScrollView {
                if useColumns {
                    // Like GeometryReaderView in the demo, use a share of the window width.
                    HStack(alignment: .top, spacing: 24) {
                        HeaderView(title: title, subtitle: subtitle, backColor: color,
                                   minimumHeight: availableHeight)
                            .frame(width: (availableWidth - 24) * 0.4)
                        form(minimumHeight: availableHeight)
                    }
                } else {
                    VStack(spacing: 24) {
                        HeaderView(title: title, subtitle: subtitle, backColor: color,
                                   minimumHeight: availableHeight * 0.3)
                        form(minimumHeight: max(0, availableHeight * 0.7 - 24))
                    }
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
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: minimumHeight)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "Remember", backColor: .pink)
}
