import SwiftUI

public struct MHorizontalRule: View {
  private let color: Color
  private let width: CGFloat
  private let height: CGFloat

  public init(color: Color = Color.primary.opacity(0.4), width: CGFloat = 50, height: CGFloat = 1) {
    self.color = color
    self.width = width
    self.height = height
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: Space.sm).frame(width: width, height: height)
      .foregroundColor(color)
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MHorizontalRule_Examples().padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
