import SwiftUI

public struct MShareButton_Examples: View {
  public init() {}

  private let item = URL(string: "https://github.com/mesqueeb/Mirage")!

  public var body: some View {
    Grid(horizontalSpacing: Space.md, verticalSpacing: Space.md) {
      GridRow {
        Text("Primary")
        MShareButton(
          item: item,
          preview: SharePreview("Mirage"),
          kind: .primary,
          label: "Share Mirage",
          icon: "square.and.arrow.up"
        )
      }

      GridRow {
        Text("Secondary")
        MShareButton(
          item: item,
          subject: Text("Mirage"),
          message: Text("A SwiftUI component library"),
          preview: SharePreview("Mirage"),
          label: "Share Mirage",
          icon: "square.and.arrow.up"
        )
      }

      GridRow {
        Text("Text")
        MShareButton(
          item: item,
          preview: SharePreview("Mirage"),
          kind: .text,
          label: "Share Mirage",
          icon: "square.and.arrow.up"
        )
      }

      GridRow {
        Text("Icon only")
        MShareButton(
          item: item,
          preview: SharePreview("Mirage"),
          iconOnly: true,
          kind: .text,
          label: "Share Mirage",
          icon: "square.and.arrow.up",
          help: "Share Mirage"
        )
      }

      GridRow {
        Text("Active and tinted")
        MShareButton(
          item: item,
          preview: SharePreview("Mirage"),
          label: "Share Mirage",
          icon: "square.and.arrow.up",
          isActive: true,
          tint: .green
        )
      }

      GridRow {
        Text("Disabled")
        MShareButton(
          item: item,
          preview: SharePreview("Mirage"),
          label: "Share Mirage",
          icon: "square.and.arrow.up",
          isDisabled: true,
          help: "Sharing is unavailable"
        )
      }
    }
  }
}
