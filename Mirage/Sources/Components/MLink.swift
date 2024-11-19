import SwiftUI

public struct MLink: View {
  let isShown: Bool
  let url: String
  let label: LocalizedStringResource?
  let icon: String?
  let content: AnyView?

  public init(
    if isShown: Bool = true,
    url: String,
    label: LocalizedStringResource? = nil,
    icon: String? = nil,
    @ViewBuilder content: () -> AnyView = { AnyView(EmptyView()) }
  ) {
    self.isShown = isShown
    self.url = url
    self.label = label
    self.icon = icon
    self.content = content()
  }

  public var body: some View {
    if isShown {
      Link(destination: URL(string: url)!) {
        Label {
          if let label { Text(label) }
        } icon: {
          if let icon { Image(systemName: icon) }
        }
        content
      }
      #if os(visionOS)
        .padding(.horizontal, Space.sm).padding(.vertical, Space.xs).foregroundStyle(Color.primary)
        .background(Color.accentColor.opacity(0.2))
      #elseif os(iOS) || os(macOS)
        .foregroundStyle(Color.accentColor)
      #endif
      .clipShape(RoundedRectangle(cornerRadius: Space.sm))
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MLink_Examples().padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
