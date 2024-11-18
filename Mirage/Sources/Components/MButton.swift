import SwiftUI

public enum ButtonKind: String { case primary, secondary, text, automatic }

public struct MButton: View {
  let isShown: Bool
  let action: () -> Void
  let kind: ButtonKind
  let label: LocalizedStringResource?
  let icon: String?
  let isActive: Bool
  let isBusy: Bool
  let isDisabled: Bool
  let tint: SwiftUI.Color?

  public init(
    if isShown: Bool = true,
    action: @escaping () -> Void,
    kind: ButtonKind = .secondary,
    label: LocalizedStringResource? = nil,
    icon: String? = nil,
    isActive: Bool = false,
    isBusy: Bool = false,
    isDisabled: Bool = false,
    tint: SwiftUI.Color? = nil
  ) {
    self.isShown = isShown
    self.action = action
    self.kind = kind
    self.label = label
    self.icon = icon
    self.isActive = isActive
    self.isBusy = isBusy
    self.isDisabled = isDisabled
    self.tint = tint
  }

  /// for tinting the background colour on macOS only
  @State private var isHovering = false
  /// State for spinner speed, sped up when tapping the button if busy
  @State private var spinnerSpeed: Double = 0

  var color: Color { return tint ?? Color.accentColor }

  public var body: some View {
    if isShown {
      Button {
        if isBusy {
          // Accelerate the spinner instead of executing the action
          withAnimation(.easeIn(duration: 0.2)) { spinnerSpeed += 1 }
        } else {
          self.action()
        }
      } label: {
        Label {
          if let label { Text(label).padding(.horizontal, 4) }
        } icon: {
          if let icon {
            Image(systemName: self.isBusy ? "progress.indicator" : icon)
              .mButtonIconModifiers(self.isBusy, spinnerSpeed)
              .contentTransition(.symbolEffect(.replace))
          } else if self.isBusy {
            Image(systemName: "progress.indicator").mButtonIconModifiers(self.isBusy, spinnerSpeed)
          }
        }
        .mButtonLabelModifiers(
          kind,
          color,
          isHovering: isHovering,
          isActive: isActive,
          hasLabel: label != nil
        )
      }
      .mButtonModifiers(kind, color, isActive: isActive, isHovering: isHovering)
      .onHover { isHovering in withAnimation { self.isHovering = isHovering } }

      // for some reason macOS BorderlessButton() style has no default disabled style
      #if os(macOS)
        .opacity(isDisabled ? 0.7 : 1.0)
      #endif
      .disabled(isDisabled)
    } else {
      EmptyView()
    }
  }
}

extension Image {
  @ViewBuilder func mButtonIconModifiers(_ isBusy: Bool, _ spinnerSpeed: Double) -> some View {
    if isBusy {
      self.symbolEffect(.rotate.wholeSymbol, options: .repeat(.continuous))
        // TODO: without `.font(.callout)` for some reason the icon does not animate
        .font(.callout).rotationEffect(.degrees(spinnerSpeed * 90))
    } else {
      self
    }
  }
}

extension Label {
  @ViewBuilder func mButtonLabelModifiers(
    _ kind: ButtonKind,
    _ tint: SwiftUI.Color?,
    isHovering: Bool,
    isActive: Bool,
    hasLabel: Bool
  ) -> some View {
    switch kind {
    case .primary, .secondary, .text:
      self.frame(minWidth: hasLabel ? 100 : nil, minHeight: 20)

        #if os(visionOS)
          .padding(.horizontal, 20).padding(.vertical, 12)
        #else
          .padding(.horizontal, 8).padding(.vertical, 4)
        #endif

    case .automatic: self
    }
  }
}

@MainActor extension Button {
  @ViewBuilder func mButtonModifiers(
    _ kind: ButtonKind,
    _ color: Color,
    isActive: Bool,
    isHovering: Bool
  ) -> some View {
    switch kind {
    case .primary:
      #if os(visionOS)
        self.buttonStyle(PlainButtonStyle()).background(color.opacity(1.0)).cornerRadius(Space.sm)
          .activeOutline(isActive, color)
      #elseif os(iOS)
        self.buttonStyle(BorderedProminentButtonStyle()).tint(color.opacity(isHovering ? 0.8 : 1.0))
          .activeOutline(isActive, color)
      #elseif os(macOS)
        self.buttonStyle(BorderlessButtonStyle()).foregroundStyle(Color.primary).colorInvert()
          .background(color.opacity(1.0)).cornerRadius(Space.xs).activeOutline(isActive, color)
      #endif

    case .secondary:
      #if os(visionOS)
        self.buttonStyle(PlainButtonStyle()).background(color.opacity(0.4)).cornerRadius(Space.sm)
          .activeOutline(isActive, color)
      #elseif os(iOS)
        self.buttonStyle(BorderedButtonStyle()).tint(color.opacity(isHovering ? 0.8 : 1))
          .activeOutline(isActive, color)
      #elseif os(macOS)
        self.buttonStyle(BorderlessButtonStyle()).foregroundStyle(color)
          .background(color.opacity(0.1)).cornerRadius(Space.xs).activeOutline(isActive, color)
      #endif

    case .text:
      #if os(visionOS)
        self.buttonStyle(PlainButtonStyle())
          .background(isActive ? color.opacity(0.1) : color.opacity(0.0)).cornerRadius(Space.sm)
          .activeOutline(isActive, color)
      #elseif os(iOS)
        self.buttonStyle(BorderlessButtonStyle()).tint(color.opacity(isHovering ? 0.8 : 1))
          .activeOutline(isActive, color)
      #elseif os(macOS)
        self.buttonStyle(BorderlessButtonStyle()).foregroundStyle(color).cornerRadius(Space.xs)
          .activeOutline(isActive, color)
      #endif

    case .automatic: self
    }
  }
}

public struct ActiveOutlineModifier: ViewModifier {
  let isActive: Bool
  let color: Color

  public init(isActive: Bool, color: Color) {
    self.isActive = isActive
    self.color = color
  }

  #if os(visionOS) || os(iOS)
    let cornerRadius: CGFloat = 10
  #elseif os(macOS)
    let cornerRadius: CGFloat = 6
  #endif

  public func body(content: Content) -> some View {
    content.padding(1.5)
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(isActive ? color.opacity(0.3) : Color.clear, lineWidth: 3)
          .animation(.easeInOut(duration: 0.2), value: isActive)
      )
  }
}

extension View {
  public func activeOutline(_ isActive: Bool, _ color: Color = Color.accentColor) -> some View {
    self.modifier(ActiveOutlineModifier(isActive: isActive, color: color))
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MButtonExamples(onTap: { print("clicked") }).padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
