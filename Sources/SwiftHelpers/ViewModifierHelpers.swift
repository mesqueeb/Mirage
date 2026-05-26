import SwiftUI

extension View {
  /// Conditionally applies a modifier to a view.
  ///
  /// ### Usage
  /// ```swift
  /// view.if(condition) { view in
  ///     view.modifier(MyModifier())
  /// }
  /// ```
  @ViewBuilder public func `if`<Content: View>(
    _ condition: Bool,
    transform: (Self) -> Content
  ) -> some View { if condition { transform(self) } else { self } }
}
