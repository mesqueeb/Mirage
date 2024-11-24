import SwiftUI

public enum ButtonKind: String, Codable, Sendable { case primary, secondary, text, automatic }

#if os(visionOS)
  let sizeModifier: CGFloat = 1.5
#elseif os(iOS)
  let sizeModifier: CGFloat = 1
#elseif os(macOS)
  let sizeModifier: CGFloat = 0.75
#endif
let defaultCornerRadius = Space.sm * sizeModifier
let defaultPadding = Space.sm * sizeModifier
let minWidthHeight = Space.lg * sizeModifier

func labelSize(hasLabel: Bool) -> (width: CGFloat, height: CGFloat) {
  return (width: hasLabel ? 100 * sizeModifier : minWidthHeight, height: minWidthHeight)
}

func buttonSize(hasLabel: Bool) -> (width: CGFloat, height: CGFloat) {
  let label = labelSize(hasLabel: hasLabel)
  let padding = defaultPadding * 2
  return (width: label.width + padding, height: label.height + padding)
}

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
          withAnimation(.easeIn(duration: 0.5)) { spinnerSpeed += 1 }
        } else {
          self.action()
        }
      } label: {
        Label {
          if let label {
            Text(label).multilineTextAlignment(.center)
              .frame(minWidth: minWidthHeight, minHeight: minWidthHeight)
          }
        } icon: {
          if let icon {
            Image(systemName: self.isBusy ? "progress.indicator" : icon)
              .mButtonIconModifiers(self.isBusy, spinnerSpeed)
          } else if self.isBusy {
            Image(systemName: "progress.indicator").mButtonIconModifiers(self.isBusy, spinnerSpeed)
          }
        }
        .mButtonLabelModifiers(kind, hasLabel: label != nil)
        // TODO: ↓ This doesn't work because we use `mButtonIconModifiers`, but other attempts at making the icon rotate continuously all failed...
        .contentTransition(.symbolEffect(.replace))
      }
      .mButtonModifiers(
        kind,
        color,
        isActive: isActive,
        isHovering: isHovering,
        hasLabel: label != nil
      )
      .onHover { isHovering in withAnimation { self.isHovering = isHovering } }  //
      #if os(macOS)
        .opacity(isDisabled ? 0.8 : 1.0)
      #endif
      .disabled(isDisabled)
    } else {
      EmptyView()
    }
  }
}

@MainActor extension View {
  @ViewBuilder fileprivate func applyPadding(hasLabel: Bool) -> some View {
    self.padding(.horizontal, (hasLabel ? (defaultPadding * 2) : defaultPadding))
      // min width and height of 30 ensures at the very least the button will be square (for this SF Symbols like "figure.stand")
      .padding(.vertical, defaultPadding)
  }
}

@MainActor extension Image {
  @ViewBuilder func mButtonIconModifiers(_ isBusy: Bool, _ spinnerSpeed: Double) -> some View {
    if isBusy {
      self.fontWeight(.medium).symbolEffect(.rotate.wholeSymbol, options: .repeat(.continuous))
        // TODO: without `.fontWeight(.medium)` for some reason the icon does not animate
        .rotationEffect(.degrees(spinnerSpeed * 90))
        .frame(minWidth: minWidthHeight, minHeight: minWidthHeight)  //
        #if os(visionOS)
          .offset(x: 2)  // there's a weird visual offset without this
        #endif
    } else {
      self.fontWeight(.medium).frame(minWidth: minWidthHeight, minHeight: minWidthHeight)  //
        #if os(visionOS)
          .offset(x: 2)  // there's a weird visual offset without this
        #endif
    }
  }
}

@MainActor extension Label {
  @ViewBuilder fileprivate func mButtonLabelModifiers(
    _ kind: ButtonKind,
    hasLabel: Bool
  ) -> some View {
    switch kind {
    case .primary, .secondary, .text:
      self.applyPadding(hasLabel: hasLabel)
        .frame(
          minWidth: buttonSize(hasLabel: hasLabel).width,
          minHeight: buttonSize(hasLabel: hasLabel).height
        )
        .contentShape(RoundedRectangle(cornerRadius: defaultCornerRadius))
    case .automatic: self
    }
  }
}

@MainActor extension Button {
  @ViewBuilder fileprivate func mButtonModifiers(
    _ kind: ButtonKind,
    _ color: Color,
    isActive: Bool,
    isHovering: Bool,
    hasLabel: Bool
  ) -> some View {
    switch kind {
    case .primary:
      self.buttonStyle(PlainButtonStyle()).applyButtonFrame(hasLabel: hasLabel)
        .foregroundStyle(Color.white).background(color.opacity(isHovering ? 0.8 : 1.0))  //
        .clipShape(RoundedRectangle(cornerRadius: defaultCornerRadius))
        .activeOutline(isActive, color)

    case .secondary:
      self.buttonStyle(PlainButtonStyle()).applyButtonFrame(hasLabel: hasLabel)
        .foregroundStyle(Color.primary)  //
        #if os(visionOS)
          // background a bit less opaque on visionOS
          .background(color.opacity(0.4))
        #else
          // background quite opaque on the rest
          .background(color.opacity(isHovering ? 0.35 : 0.2))
        #endif

        .clipShape(RoundedRectangle(cornerRadius: defaultCornerRadius))
        .activeOutline(isActive, color)

    case .text:
      self.buttonStyle(PlainButtonStyle()).applyButtonFrame(hasLabel: hasLabel)  //
        #if os(visionOS)
          // primary color on visionOS
          .foregroundStyle(Color.primary.opacity(isHovering ? 0.8 : 1.0))
        #else
          // accentColor on the rest
          .foregroundStyle(color.opacity(isHovering ? 0.8 : 1.0))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: defaultCornerRadius))
        .activeOutline(isActive, color)

    case .automatic: self
    }
  }
}

@MainActor extension View {
  /// the button won't respect the inner label's min height/width in a constraint View so
  /// we need an extra frame on the outer button
  @ViewBuilder fileprivate func applyButtonFrame(hasLabel: Bool) -> some View {
    self  //
      #if os(visionOS)
        .padding(-12)  // negative padding to make the hover spotlight look nicely
        .frame(
          minWidth: buttonSize(hasLabel: hasLabel).width - 12,
          minHeight: buttonSize(hasLabel: hasLabel).height - 12
        )
      #else
        .frame(
          minWidth: buttonSize(hasLabel: hasLabel).width,
          minHeight: buttonSize(hasLabel: hasLabel).height
        )
      #endif
  }
}

fileprivate struct ActiveOutlineModifier: ViewModifier {
  let isActive: Bool
  let color: Color

  init(isActive: Bool, color: Color) {
    self.isActive = isActive
    self.color = color
  }

  func body(content: Content) -> some View {
    content.padding(1.5)
      .overlay(
        RoundedRectangle(cornerRadius: defaultCornerRadius + 2)
          .stroke(isActive ? color.opacity(0.3) : Color.clear, lineWidth: 3)
          .animation(.easeInOut(duration: 0.2), value: isActive)
      )
  }
}

extension View {
  fileprivate func activeOutline(_ isActive: Bool, _ color: Color = Color.accentColor) -> some View
  { self.modifier(ActiveOutlineModifier(isActive: isActive, color: color)) }
}

#Preview(traits: .sizeThatFitsLayout) {
  MButton_Examples(onTap: { print("clicked") }).padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
