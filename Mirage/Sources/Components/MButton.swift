import SwiftUI

fileprivate enum OperatingSystem: String, Codable, Sendable { case visionOS, macOS, iOS }

#if os(visionOS)
  fileprivate let OS = OperatingSystem.visionOS
#elseif os(macOS)
  fileprivate let OS = OperatingSystem.macOS
#elseif os(iOS)
  fileprivate let OS = OperatingSystem.iOS
#endif

public enum ButtonKind: String, Codable, Sendable {
  case primary, secondary, text, textPrimary, automatic
}
public enum LabelKind: String, Codable, Sendable { case labelAndIcon, labelOnly, iconOnly }

fileprivate let sizeModifier: CGFloat =
  switch OS {
  case .visionOS: 1.5
  case .iOS: 1
  case .macOS: 0.75
  }

public struct MButton: View {
  let isShown: Bool
  let action: () -> Void
  let iconOnly: Bool
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
    iconOnly: Bool = false,
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
    self.iconOnly = iconOnly
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

  private var accentColor: Color { return tint ?? Color.accentColor }
  private var labelKind: LabelKind {
    return iconOnly ? .iconOnly : icon != nil ? .labelAndIcon : .labelOnly
  }

  private var cornerRadius: CGFloat {
    return switch labelKind {
    case .labelAndIcon, .labelOnly: Space.sm * sizeModifier
    case .iconOnly: 9999999
    }
  }
  private var defaultPadding: CGFloat {
    if OS == .visionOS && labelKind == .iconOnly { return Space.sm * 2 }
    return Space.sm * sizeModifier
  }
  private var minWidthHeight: CGFloat {
    if labelKind == .iconOnly { return Space.md * sizeModifier }
    return Space.lg * sizeModifier
  }
  private var paddingSize: (x: CGFloat, y: CGFloat) {
    let x =
      switch labelKind {
      case .labelAndIcon, .labelOnly: defaultPadding * 2
      case .iconOnly: defaultPadding
      }
    // min width and height of 30 ensures at the very least the button will be square (for this SF Symbols like "figure.stand")
    let y = defaultPadding
    return (x: x, y: y)
  }
  private var labelSize: CGSize {
    let width =
      if label == nil || labelKind == .iconOnly { minWidthHeight } else { 100 * sizeModifier }
    return CGSize(width: width, height: minWidthHeight)
  }
  /// labelSize + padding
  private var buttonSize: CGSize {
    return CGSize(
      width: labelSize.width + paddingSize.x * 2,
      height: labelSize.height + paddingSize.y * 2
    )
  }

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
            if iconOnly {
              Text(label)
            } else {
              Text(label).multilineTextAlignment(.center)
                .frame(minWidth: minWidthHeight, minHeight: minWidthHeight)
            }
          }
        } icon: {
          if let iconName = isBusy ? "progress.indicator" : icon {
            Image(systemName: iconName)
              .if(labelKind == .iconOnly) { view in view.resizable().aspectRatio(contentMode: .fit)
              }
              // without `.fontWeight(.medium)` for some reason the icon does not animate
              .fontWeight(.medium)  //
              .if(isBusy) { view in
                view.symbolEffect(.rotate.wholeSymbol, options: .repeat(.continuous))
                  .rotationEffect(.degrees(spinnerSpeed * 90))
              }
              .frame(width: minWidthHeight, height: minWidthHeight)  //
              #if os(visionOS)
                .offset(x: labelKind == .iconOnly ? 0 : 2)  // there's a weird visual offset without this
              #endif
          }
        }
        .if(kind != .automatic) { view in
          view.padding(.horizontal, paddingSize.x)  //
            .padding(.vertical, paddingSize.y)  //
            .frame(minWidth: buttonSize.width, minHeight: buttonSize.height)  //
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .if(labelKind == .iconOnly) { view in view.labelStyle(.iconOnly) }
        // TODO: ↓ This doesn't work because we use `mButtonIconModifiers`, but other attempts at making the icon rotate continuously all failed...
        .contentTransition(.symbolEffect(.replace))
      }
      // Button base
      .if(kind != .automatic) { view in
        view.buttonStyle(PlainButtonStyle())  //
          .applyButtonFrame(buttonSize)  //
      }
      // Button colors
      .mButtonColorModifiers(kind, accentColor, isHovering: isHovering)  //
      // Button outer clip
      .if(kind != .automatic) { view in
        view.clipShape(RoundedRectangle(cornerRadius: cornerRadius))  //
          .activeOutline(
            isActive,
            accentColor,
            shape: RoundedRectangle(cornerRadius: cornerRadius + 2)
          )
      }
      .onHover { isHovering in withAnimation { self.isHovering = isHovering } }  //
      #if os(macOS)
        // it's not always clear without this on macOS
        .opacity(isDisabled ? 0.8 : 1.0)
      #endif
      .disabled(isDisabled)
    } else {
      EmptyView()
    }
  }
}

@MainActor extension View {
  @ViewBuilder fileprivate func mButtonColorModifiers(
    _ kind: ButtonKind,
    _ accentColor: Color,
    isHovering: Bool
  ) -> some View {
    switch kind {
    case .primary:
      self.foregroundStyle(Color.white)  //
        .background(accentColor.opacity(isHovering ? 0.8 : 1.0))  //
    case .secondary:
      self.foregroundStyle(Color.primary)  //
        .background(
          accentColor.opacity(
            OS == .visionOS
              ? 0.4  // background a bit less opaque on visionOS
              : isHovering ? 0.35 : 0.2  // background quite opaque on the rest
          )
        )
    case .text, .textPrimary:
      self.foregroundStyle(
        OS == .visionOS || kind == .text
          ? Color.primary.opacity(isHovering ? 0.8 : 1.0)  // always use primary color on visionOS and text kind
          : accentColor.opacity(isHovering ? 0.8 : 1.0)  // use accentColor for textPrimary on the rest
      )
    case .automatic: self
    }
  }
}

@MainActor extension View {
  /// the button won't respect the inner label's min height/width in a constraint View so
  /// we need an extra frame on the outer button
  @ViewBuilder fileprivate func applyButtonFrame(_ buttonSize: CGSize) -> some View {
    #if os(visionOS)
      // negative padding is to make the hover spotlight look nicely
      self.padding(-12)  //
        .frame(minWidth: buttonSize.width - 12, minHeight: buttonSize.height - 12)
    #else
      self.frame(minWidth: buttonSize.width, minHeight: buttonSize.height)
    #endif
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
  MButton_Examples(onTap: { print("clicked") }).padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
