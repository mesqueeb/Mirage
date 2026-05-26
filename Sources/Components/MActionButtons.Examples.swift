import SwiftUI

public struct MActionButtons_Examples: View {
  let onTap: () -> Void

  public init(onTap: @escaping () -> Void) { self.onTap = onTap }

  public var body: some View {
    MActionButtons(actionButtons: [
      MActionButton(action: { _ in onTap() }, label: "Favourite", icon: "heart"),
      MActionButton(action: { _ in onTap() }, label: "Share", icon: "square.and.arrow.up"),
    ])
  }
}
