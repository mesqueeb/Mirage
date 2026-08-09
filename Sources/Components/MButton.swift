import SwiftUI

public enum ButtonKind: String, Codable, Sendable {
  case primary, secondary, text, textPrimary, automatic

  public func colorForeground(_ accentColor: Color, isHovering: Bool) -> Color {
    switch self {
    case .primary: .white
    case .secondary: .primary
    case .text: .primary.opacity(isHovering ? 0.8 : 1)
    case .textPrimary:
      #if os(visionOS)
        (Color.primary).opacity(isHovering ? 0.8 : 1)
      #else
        (accentColor).opacity(isHovering ? 0.8 : 1)
      #endif
    case .automatic: accentColor
    }
  }

  public func colorBackground(_ accentColor: Color, isHovering: Bool) -> Color {
    switch self {
    case .primary: accentColor.opacity(isHovering ? 0.8 : 1)
    case .secondary:
      #if os(visionOS)
        accentColor.opacity(0.4)
      #else
        accentColor.opacity(isHovering ? 0.35 : 0.2)
      #endif
    case .text, .textPrimary, .automatic: .clear
    }
  }
}

public enum LabelKind: String, Codable, Sendable { case labelAndIcon, labelOnly, iconOnly }

public struct MButton<Content: View>: View {
  let isShown: Bool
  /// Synchronous tap handler. `nil` when an async action was supplied instead.
  let action: (() -> Void)?
  /// Asynchronous tap handler. While it runs, the button drives the spinner automatically.
  let asyncAction: (() async -> Void)?
  let iconOnly: Bool
  let kind: ButtonKind
  let label: LocalizedStringResource?
  let icon: String?
  let isActive: Bool
  let isBusy: Bool
  let isDisabled: Bool
  let help: LocalizedStringResource?
  let tint: SwiftUI.Color?
  let width: CGFloat?
  let height: CGFloat?
  let extraContent: () -> Content

  public init(
    if isShown: Bool = true,
    action: @escaping () -> Void,
    iconOnly: Bool = false,
    kind: ButtonKind = .secondary,
    label: LocalizedStringResource? = nil,
    icon: String? = nil,
    isActive: Bool = false,
    isBusy: Bool = false,
    isDisabled: Bool = false,
    help: LocalizedStringResource? = nil,
    tint: SwiftUI.Color? = nil,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    @ViewBuilder extraContent: @escaping () -> Content = { EmptyView() }
  ) {
    self.isShown = isShown
    self.action = action
    self.asyncAction = nil
    self.iconOnly = iconOnly
    self.kind = kind
    self.label = label
    self.icon = icon
    self.isActive = isActive
    self.isBusy = isBusy
    self.isDisabled = isDisabled
    self.help = help
    self.tint = tint
    self.width = width
    self.height = height
    self.extraContent = extraContent
  }

  /// Async variant: while `action` is running the button shows the busy spinner automatically.
  /// The explicit `isBusy` flag still forces the busy state on top of the automatic one.
  public init(
    if isShown: Bool = true,
    action: @escaping () async -> Void,
    iconOnly: Bool = false,
    kind: ButtonKind = .secondary,
    label: LocalizedStringResource? = nil,
    icon: String? = nil,
    isActive: Bool = false,
    isBusy: Bool = false,
    isDisabled: Bool = false,
    help: LocalizedStringResource? = nil,
    tint: SwiftUI.Color? = nil,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    @ViewBuilder extraContent: @escaping () -> Content = { EmptyView() }
  ) {
    self.isShown = isShown
    self.action = nil
    self.asyncAction = action
    self.iconOnly = iconOnly
    self.kind = kind
    self.label = label
    self.icon = icon
    self.isActive = isActive
    self.isBusy = isBusy
    self.isDisabled = isDisabled
    self.help = help
    self.tint = tint
    self.width = width
    self.height = height
    self.extraContent = extraContent
  }

  /// for tinting the background colour on macOS only
  @State private var isHovering = false
  @State private var spinnerRotation = 0.0
  /// `true` while the async action is executing; combined with `isBusy` to drive the spinner.
  @State private var isRunningAsync = false

  /// The effective busy state: explicit `isBusy` prop OR an in-flight async action.
  private var effectiveIsBusy: Bool { isBusy || isRunningAsync }

  private var presentation: MButtonPresentation {
    MButtonPresentation(
      iconOnly: iconOnly,
      kind: kind,
      label: label,
      icon: icon,
      isActive: isActive,
      isBusy: effectiveIsBusy,
      isDisabled: isDisabled,
      help: help,
      tint: tint,
      width: width,
      height: height
    )
  }

  public var body: some View {
    if isShown {
      Button {
        if isDisabled {
          return
        } else if effectiveIsBusy {
          withAnimation(.linear(duration: 0.4)) { spinnerRotation += 360 }
        } else if let asyncAction {
          // Drive the busy spinner automatically for the duration of the async action
          Task {
            isRunningAsync = true
            defer { isRunningAsync = false }
            await asyncAction()
          }
        } else {
          self.action?()
        }
      } label: {
        presentation.label(
          spinnerRotation: spinnerRotation,
          isHovering: isHovering,
          extraContent: extraContent
        )
      }
      .mButtonAppearance(presentation, isHovering: $isHovering)
    } else {
      EmptyView()
    }
  }
}

fileprivate struct ActiveOutlineModifier<S: Shape>: ViewModifier {
  let isActive: Bool
  let color: Color
  let shape: S

  init(isActive: Bool, color: Color, shape: S) {
    self.isActive = isActive
    self.color = color
    self.shape = shape
  }

  func body(content: Content) -> some View {
    content.padding(1.5)
      .overlay(
        shape.stroke(isActive ? color.opacity(0.3) : Color.clear, lineWidth: 3)
          .animation(.easeInOut(duration: 0.2), value: isActive)
      )
  }
}

extension View {
  public func activeOutline<S: Shape>(
    _ isActive: Bool,
    _ color: Color = Color.accentColor,
    shape: S
  ) -> some View {
    self.modifier(ActiveOutlineModifier(isActive: isActive, color: color, shape: shape))
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MButton_Examples(onTap: { print("clicked") }).padding()  //
    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
