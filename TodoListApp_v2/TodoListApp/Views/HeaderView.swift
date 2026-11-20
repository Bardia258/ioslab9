import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let backColor: Color

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
        .frame(maxWidth: .infinity)
        .background(backColor, in: RoundedRectangle(cornerRadius: 20))
    }
}

// Shared layout for both authentication screens.
// Measure the container, not the physical device's screen.
struct AdaptiveAuthLayout<Content: View>: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let title: String
    let subtitle: String
    let color: Color
    @ViewBuilder let content: () -> Content

    private var header: some View {
        HeaderView(title: title, subtitle: subtitle, backColor: color)
    }

    var body: some View {
        GeometryReader { geometry in
            let short = verticalSizeClass == .compact || geometry.size.height < 450
            let wide = !dynamicTypeSize.isAccessibilitySize &&
                (geometry.size.width >= 700 || (short && geometry.size.width >= 600))
            // Changing the layout keeps the same fields and their focus/state.
            let layout = wide
                ? AnyLayout(HStackLayout(alignment: .center, spacing: 24))
                : AnyLayout(VStackLayout(spacing: 24))

            ScrollView {
                layout {
                    header
                        .frame(maxWidth: wide ? 340 : .infinity)
                    content()
                        .frame(maxWidth: 420)
                }
                .frame(maxWidth: wide ? 800 : 420)
                .frame(maxWidth: .infinity,
                       minHeight: max(0, geometry.size.height - 40),
                       alignment: short ? .top : .center)
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "Remember", backColor: .pink)
}
