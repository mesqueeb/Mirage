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

  /// for tinting the background colour on macOS only
  @State private var isHovering = false

  public var body: some View {
    if isShown {
      Link(destination: URL(string: url)!) {
        HStack {
          Label {
            if let label { Text(label) }
          } icon: {
            if let icon { Image(systemName: icon) }
          }
          content
        }
        #if os(visionOS)
          .padding(.horizontal, (label != nil ? Space.md : Space.sm) + 4)
          .padding(.vertical, Space.sm + 4).background(Color.accentColor.opacity(0.1))
        #endif
      }
      #if os(visionOS)
        .padding(-6).clipShape(RoundedRectangle(cornerRadius: Space.sm))
        .foregroundStyle(Color.primary)
      #elseif os(iOS) || os(macOS)
        .foregroundStyle(Color.accentColor.opacity(isHovering ? 0.8 : 1.0))
        .onHover { isHovering in withAnimation { self.isHovering = isHovering } }
      #endif
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
