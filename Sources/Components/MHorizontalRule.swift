import SwiftUI

@MainActor extension View {
  @ViewBuilder fileprivate func applyHrFrame(width: CGFloat, height: CGFloat) -> some View {
    // Compute (minWidth, maxWidth)
    let (minWidth, maxWidth): (CGFloat, CGFloat) =
      width.isInfinite ? (0, .infinity) : (width, width)
    // Compute (minHeight, maxHeight)
    let (minHeight, maxHeight): (CGFloat, CGFloat) =
      height.isInfinite ? (0, .infinity) : (height, height)
    // Finally, apply all at once
    self.frame(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      alignment: .center
    )
  }
}

/// A horizontal line.
///
/// By default it will be 1px high and grow horizontally as wide as the parent frame.
/// You can also pass a `width` and/or `height`
public struct MHorizontalRule: View {
  private let color: Color
  private let width: CGFloat
  private let height: CGFloat

  public init(
    color: Color = Color.primary.opacity(0.4),
    width: CGFloat = .infinity,
    height: CGFloat = 1
  ) {
    self.color = color
    self.width = width
    self.height = height
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: Space.sm).applyHrFrame(width: width, height: height)
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
