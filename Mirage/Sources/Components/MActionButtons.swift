import SwiftUI

/// Some action buttons are given a dismiss function you can execute inside of your action.
/// This will allow you to dismiss whatever View is currently showing the action.
public typealias DismissFn = () -> Void

/// A data representation of a button
///
/// Used for cases where buttons are dynamically defined in a parent.
/// Eg. a component that defines a `[ActionButton]` prop, based on which it will render button components in its body.
public struct MActionButton: Identifiable {
  public let id: UUID
  public let action: (DismissFn?) -> Void
  public let label: LocalizedStringResource?
  public let icon: String?
  public let isActive: Bool
  public let isBusy: Bool
  public let isDisabled: Bool

  public init(
    action: @escaping (DismissFn?) -> Void,
    label: LocalizedStringResource? = nil,
    icon: String? = nil,
    isActive: Bool = false,
    isBusy: Bool = false,
    isDisabled: Bool = false
  ) {
    self.id = UUID()
    self.action = action
    self.label = label
    self.icon = icon
    self.isActive = isActive
    self.isBusy = isBusy
    self.isDisabled = isDisabled
  }
}

public struct MActionButtons: View {
  private let actionButtons: [MActionButton]
  private let dismissFn: DismissFn?

  public init(actionButtons: [MActionButton], dismissFn: DismissFn? = nil) {
    self.actionButtons = actionButtons
    self.dismissFn = dismissFn
  }

  public var body: some View {
    VStack(spacing: Space.md) {
      ForEach(actionButtons) { actionButton in
        MButton(
          action: { actionButton.action(self.dismissFn) },
          label: actionButton.label,
          icon: actionButton.icon,
          isActive: actionButton.isActive,
          isBusy: actionButton.isBusy,
          isDisabled: actionButton.isDisabled
        )
        .id(actionButton.id)
      }
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MActionButtons_Examples(onTap: { print("Huzzah!") }).padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
