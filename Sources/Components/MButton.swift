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

public struct MButton<Content: View>: View {
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
    tint: SwiftUI.Color? = nil,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    @ViewBuilder extraContent: @escaping () -> Content = { EmptyView() }
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
    self.width = width
    self.height = height
    self.extraContent = extraContent
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
  private var buttonDimensions: CGSize {
    return CGSize(
      width: labelSize.width + paddingSize.x * 2,
      height: labelSize.height + paddingSize.y * 2
    )
  }

  /// Without offsetting the text slightly on the y axis, to me it doesn't truly feel like the icon and text are centered...
  var yTextOffset: CGFloat {
    return if icon == nil && !isBusy { 0 } else {
      switch OS {
      case .visionOS: -1.5
      case .iOS: -0.5
      case .macOS: -0.5
      }
    }
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
        HStack {
          Label {
            if let label {
              Text(label)
                .if(labelKind != .iconOnly) { view in
                  view.offset(y: yTextOffset)  // this makes the text a bit better centered imo
                    .frame(minWidth: minWidthHeight, minHeight: minWidthHeight)
                    .multilineTextAlignment(.center)
                }
            }
          } icon: {
            if let iconName = isBusy ? "progress.indicator" : icon {
              Image(systemName: iconName)
                .if(labelKind == .iconOnly) { view in
                  view.resizable().aspectRatio(contentMode: .fit)
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
          extraContent().offset(y: yTextOffset)  // this makes the text a bit better centered imo
        }
        .if(kind != .automatic) { view in
          view.padding(.horizontal, paddingSize.x).padding(.vertical, paddingSize.y)
            // apply frame both on inner and outer layer so the entire button is tappable
            .applyButtonFrame(buttonDimensions, width: width, height: height)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .if(labelKind == .iconOnly) { view in view.labelStyle(.iconOnly) }
        // TODO: ↓ This doesn't work because we use `mButtonIconModifiers`, but other attempts at making the icon rotate continuously all failed...
        .contentTransition(.symbolEffect(.replace))
      }
      // Button base
      .if(kind != .automatic) { view in
        view.buttonStyle(PlainButtonStyle())  //
          // apply frame both on inner and outer layer so the entire button is tappable
          .if(OS == .visionOS) { view in view.padding(-12) }
          .applyButtonFrame(buttonDimensions, width: width, height: height, modifier: -12)
      }
      // Button colors
      .mButtonColorModifiers(kind, accentColor, isHovering: isHovering)
      .if(kind != .automatic) { view in
        // Button outer clip
        view.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
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
        .background(accentColor.opacity(isHovering ? 0.8 : 1.0))
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
  @ViewBuilder fileprivate func applyButtonFrame(
    /// button defaults
    _ buttonDimensions: CGSize,
    /// passed width
    width: CGFloat?,
    /// passed height
    height: CGFloat?,
    // on visionOS we pass negative padding is to make the hover spotlight look nicely on visionOS
    modifier: CGFloat = 0
  ) -> some View {
    // Compute (minWidth, maxWidth)
    let (minWidth, maxWidth): (CGFloat?, CGFloat?) = {
      switch width {
      case .none:
        // No width provided -> use the computed default as a strict minimum
        return (buttonDimensions.width + modifier, nil)
      case .some(let w) where w.isInfinite:
        // .infinity -> expand to fill parent
        return (0, .infinity)
      case .some(let w):
        // Finite width -> exact fixed width
        return (w + modifier, w + modifier)
      }
    }()

    // Compute (minHeight, maxHeight)
    let (minHeight, maxHeight): (CGFloat?, CGFloat?) = {
      switch height {
      case .none:
        // No height provided -> use the computed default as a strict minimum
        return (buttonDimensions.height + modifier, nil)
      case .some(let h) where h.isInfinite:
        // .infinity -> expand to fill parent vertically
        return (0, .infinity)
      case .some(let h):
        // Finite height -> exact fixed height
        return (h + modifier, h + modifier)
      }
    }()

    // Finally, apply all at once
    self.frame(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      alignment: .center
    )
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
