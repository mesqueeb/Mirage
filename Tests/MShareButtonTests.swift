import Foundation
import SwiftUI
import Testing

@testable import Mirage

@MainActor struct MShareButtonTests {
  @Test func initializerStoresTheMButtonPresentationProperties() {
    let button = MShareButton(
      item: URL(string: "https://example.com")!,
      preview: SharePreview("Example"),
      iconOnly: true,
      kind: .text,
      label: "Share",
      icon: "square.and.arrow.up",
      isActive: true,
      isDisabled: true,
      help: "Share",
      tint: .green,
      width: 60,
      height: 44
    )

    #expect(button.iconOnly)
    #expect(button.kind == .text)
    #expect(button.icon == "square.and.arrow.up")
    #expect(button.isActive)
    #expect(button.isDisabled)
    #expect(button.tint == .green)
    #expect(button.width == 60)
    #expect(button.height == 44)
  }
}
