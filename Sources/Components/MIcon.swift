import Foundation

public struct MIcon: ExpressibleByStringLiteral, Hashable, Sendable {
  public let systemName: String
  public let rotationDegrees: Double
  public let isMirroredHorizontally: Bool

  public init(systemName: String, rotationDegrees: Double = 0, isMirroredHorizontally: Bool = false)
  {
    self.systemName = systemName
    self.rotationDegrees = rotationDegrees
    self.isMirroredHorizontally = isMirroredHorizontally
  }

  public init(stringLiteral value: String) { self.init(systemName: value) }

  public static func sfSymbol(_ name: String) -> Self { Self(systemName: name) }

  public func rotated(_ degrees: Double) -> Self {
    Self(
      systemName: systemName,
      rotationDegrees: rotationDegrees + degrees,
      isMirroredHorizontally: isMirroredHorizontally
    )
  }

  public func mirroredHorizontally() -> Self {
    Self(
      systemName: systemName,
      rotationDegrees: rotationDegrees,
      isMirroredHorizontally: !isMirroredHorizontally
    )
  }
}
