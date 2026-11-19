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
            Text(subtitle)
                .font(.title3)
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
    let title: String
    let subtitle: String
    let color: Color
    @ViewBuilder let content: () -> Content

    private var header: some View {
        HeaderView(title: title, subtitle: subtitle, backColor: color)
    }

    var body: some View {
        GeometryReader { geometry in
            let wide = geometry.size.width >= 700 ||
                (verticalSizeClass == .compact && geometry.size.width >= 520)

            ScrollView {
                if wide {
                    HStack(alignment: .center, spacing: 24) {
                        header
                            .frame(maxWidth: 340)
                        content()
                            .frame(maxWidth: 420)
                    }
                    .frame(maxWidth: 800)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                } else {
                    VStack(spacing: 24) {
                        header
                        content()
                    }
                    .frame(maxWidth: 420)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "Remember", backColor: .pink)
}
