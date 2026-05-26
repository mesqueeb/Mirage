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
      VStack {
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
            exampleCell(
              text: "Rounded HR",
              hr: MHorizontalRule(color: .green, width: 80, height: 3)
            )
            exampleCell(
              text: "Custom Combo",
              hr: MHorizontalRule(color: .orange, width: 70, height: 4)
            )
          }
        }

        MHorizontalRule(width: .infinity)

        Text("Width")

        VStack(spacing: Space.md) {
          Text("this HR will have its default width applied")
          MHorizontalRule()
          Text("this HR will be 500px wide")
          MHorizontalRule(width: 500)
          Text("this HR will grow until its parent frame")
          MHorizontalRule(width: .infinity)
          Text("That's all")
        }
        .frame(width: 600).border(.brown, width: 1).padding()

        VStack(spacing: Space.md) {
          Text("this HR will have its default width applied")
          MHorizontalRule()
          Text("this HR will be 500px wide")
          MHorizontalRule(width: 500)
          Text("this HR will grow until its parent frame")
          MHorizontalRule(width: .infinity)
          Text("That's all")
        }
        .frame(width: 70).border(.brown, width: 1).padding()

        MHorizontalRule(width: .infinity)

        Text("Height")

        HStack(spacing: Space.md) {
          MHorizontalRule()
          MHorizontalRule(height: 40)
          MHorizontalRule(height: .infinity)
        }
        .frame(height: 60).border(.brown, width: 1).padding()

        HStack(spacing: Space.md) {
          MHorizontalRule()
          MHorizontalRule(height: 40)
          MHorizontalRule(height: .infinity)
        }
        .frame(height: 10).border(.brown, width: 1).padding()
      }
    }
  }

}
