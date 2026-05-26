import SwiftUI

public struct MLink_Examples: View {
  public init() {}

  public var body: some View {
    VStack(spacing: Space.lg) {
      Text("Here is some text")
      MLink(url: "https://craftingtable.studio", label: "click me", icon: "arrow.up.right.square")
      Text("and some more text.")
      MLink(url: "https://craftingtable.studio", label: "click me")
      MLink(url: "https://craftingtable.studio", icon: "play.square.fill")
    }
  }
}
