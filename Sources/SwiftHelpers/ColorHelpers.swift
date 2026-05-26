import SwiftUI

#if canImport(UIKit)
  import UIKit

  extension Color {
    public static let background = Color(UIColor.systemBackground)
    public static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    public static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)

    /// Darkens a color by blending it with black by a certain percentage.
    public func darken(by percentage: Float) -> Color {
      // Ensure percentage is clamped between 0 and 1
      let darkenFactor = 1 - min(max(percentage, 0), 1)
      return self.opacity(Double(darkenFactor))
    }
  }
#elseif canImport(AppKit)
  import AppKit

  extension NSColor {
    static func from(color: Color) -> NSColor? {
      // Attempt to get the CGColor from the SwiftUI Color
      guard let cgColor = color.cgColor else { return nil }
      // Initialize an NSColor with the CGColor
      return NSColor(cgColor: cgColor)
    }
  }

  extension Color {
    public static let background = Color(NSColor.windowBackgroundColor)
    public static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    public static let tertiaryBackground = Color(NSColor.controlBackgroundColor)

    /// Darkens a color by blending it with black by a certain percentage.
    public func darken(by percentage: Float) -> Color {
      // Clamp percentage between 0 and 1
      let clampedPercentage = max(min(percentage, 1), 0)
      guard let nsColor = NSColor.from(color: self) else { return self }
      var hue: CGFloat = 0
      var saturation: CGFloat = 0
      var brightness: CGFloat = 0
      var alpha: CGFloat = 0
      nsColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      let newBrightness = brightness * CGFloat(1 - clampedPercentage)
      return Color(
        NSColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
      )
    }
  }
#endif
