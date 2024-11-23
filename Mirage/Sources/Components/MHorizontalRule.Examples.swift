import SwiftUI

public struct MHorizontalRule_Examples: View {
  public init() {}

  @ViewBuilder private func exampleCell(text: String, hr: MHorizontalRule) -> some View {
    VStack {
      Text(text).font(.caption)
      hr
      Text("Below HR").font(.caption2)
    }
    .padding().background(Color(Color.secondaryBackground)).cornerRadius(8).shadow(radius: 2)
  }

  public var body: some View {
    ScrollView {
      Grid(horizontalSpacing: 20, verticalSpacing: 20) {
        GridRow {
          exampleCell(text: "Default HR", hr: MHorizontalRule())
          exampleCell(text: "Thick Line", hr: MHorizontalRule(height: 5))
          exampleCell(text: "Thin Line", hr: MHorizontalRule(height: 0.5))
        }
        GridRow {
          exampleCell(text: "Red HR", hr: MHorizontalRule(color: .red))
          exampleCell(text: "Wide HR", hr: MHorizontalRule(width: 100))
          exampleCell(text: "Narrow HR", hr: MHorizontalRule(width: 30))
        }
        GridRow {
          exampleCell(text: "Custom Opacity", hr: MHorizontalRule(color: Color.blue.opacity(0.6)))
          exampleCell(text: "Rounded HR", hr: MHorizontalRule(color: .green, width: 80, height: 3))
          exampleCell(
            text: "Custom Combo",
            hr: MHorizontalRule(color: .orange, width: 70, height: 4)
          )
        }
      }
      .padding()
    }
  }

}
