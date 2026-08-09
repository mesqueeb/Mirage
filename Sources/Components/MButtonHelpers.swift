import SwiftUI

private enum MButtonOperatingSystem: String, Codable, Sendable { case visionOS, macOS, iOS }

#if os(visionOS)
  private let mButtonOS = MButtonOperatingSystem.visionOS
#elseif os(macOS)
  private let mButtonOS = MButtonOperatingSystem.macOS
#elseif os(iOS)
  private let mButtonOS = MButtonOperatingSystem.iOS
#endif

private let mButtonSizeModifier: CGFloat =
  switch mButtonOS {
  case .visionOS: 1.5
  case .iOS: 1
  case .macOS: 0.75
  }

struct MButtonPresentation {
  let iconOnly: Bool
  let kind: ButtonKind
  let label: LocalizedStringResource?
  let icon: String?
  let isActive: Bool
  let isBusy: Bool
  let isDisabled: Bool
  let help: LocalizedStringResource?
  let tint: Color?
  let width: CGFloat?
  let height: CGFloat?

  private var accentColor: Color { tint ?? Color.accentColor }
  private var labelKind: LabelKind {
    iconOnly ? .iconOnly : icon != nil ? .labelAndIcon : .labelOnly
  }
  private var cornerRadius: CGFloat {
    switch labelKind {
    case .labelAndIcon, .labelOnly: Space.sm * mButtonSizeModifier
    case .iconOnly: 9_999_999
    }
  }
  private var defaultPadding: CGFloat {
    if mButtonOS == .visionOS && labelKind == .iconOnly { return Space.sm * 2 }
    return Space.sm * mButtonSizeModifier
  }
  private var minWidthHeight: CGFloat {
    labelKind == .iconOnly ? Space.md * mButtonSizeModifier : Space.lg * mButtonSizeModifier
  }
  private var paddingSize: (x: CGFloat, y: CGFloat) {
    let x =
      switch labelKind {
      case .labelAndIcon, .labelOnly: defaultPadding * 2
      case .iconOnly: defaultPadding
      }
    return (x: x, y: defaultPadding)
  }
  private var labelSize: CGSize {
    let width =
      if label == nil || labelKind == .iconOnly { minWidthHeight } else {
        100 * mButtonSizeModifier
      }
    return CGSize(width: width, height: minWidthHeight)
  }
  private var buttonDimensions: CGSize {
    CGSize(width: labelSize.width + paddingSize.x * 2, height: labelSize.height + paddingSize.y * 2)
  }

  @MainActor @ViewBuilder func label<Content: View>(
    spinnerRotation: Double,
    isHovering: Bool,
    @ViewBuilder extraContent: () -> Content
  ) -> some View {
    HStack(alignment: .center) {
      if isBusy {
        ProgressView().tint(kind.colorForeground(accentColor, isHovering: isHovering))
          .progressViewStyle(.circular).controlSize(.small)
          .scaleEffect(mButtonOS == .macOS ? 1 : 1.25).rotationEffect(.degrees(spinnerRotation))
          .frame(width: minWidthHeight, height: minWidthHeight)  //
      } else if let icon {
        Image(systemName: icon)
          .if(labelKind == .iconOnly) { view in view.resizable().aspectRatio(contentMode: .fit) }
          .fontWeight(.medium)  //
          .frame(width: minWidthHeight, height: minWidthHeight)  //
      }
      if labelKind != .iconOnly, let label {
        Text(label).frame(minWidth: minWidthHeight, minHeight: minWidthHeight)
          .multilineTextAlignment(.center)
      }
      extraContent()
    }
    .if(kind != .automatic) { view in
      view.padding(.horizontal, paddingSize.x).padding(.vertical, paddingSize.y)
        .applyMButtonFrame(buttonDimensions, width: width, height: height)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    .contentTransition(.symbolEffect(.replace))
    .accessibilityLabel(label ?? "", isEnabled: labelKind == .iconOnly && label != nil)
  }

  @MainActor @ViewBuilder func apply<Content: View>(
    to content: Content,
    isHovering: Binding<Bool>
  ) -> some View {
    content.if(kind != .automatic) { view in
      view.buttonStyle(PlainButtonStyle())  //
        .if(mButtonOS == .visionOS) { view in view.padding(-12) }
        .applyMButtonFrame(
          buttonDimensions,
          width: width,
          height: height,
          modifier: mButtonOS == .visionOS ? -12 : 0
        )
    }
    .mButtonColorModifiers(kind, accentColor, isHovering: isHovering.wrappedValue && !isDisabled)
    .if(kind != .automatic) { view in
      view.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .activeOutline(
          isActive,
          accentColor,
          shape: RoundedRectangle(cornerRadius: cornerRadius + 2)
        )
    }
    .onHover { hovering in withAnimation { isHovering.wrappedValue = hovering } }  //
    #if os(macOS)
      .opacity(isDisabled ? 0.8 : 1)
    #endif
    #if os(visionOS)
      .saturation(isDisabled ? 0 : 1).opacity(isDisabled ? 0.5 : 1)
    #else
      .disabled(isDisabled)
    #endif
    .mButtonHelp(help, isDisabled: isDisabled)
  }
}

@MainActor extension View {
  @ViewBuilder func mButtonAppearance(
    _ presentation: MButtonPresentation,
    isHovering: Binding<Bool>
  ) -> some View { presentation.apply(to: self, isHovering: isHovering) }

  @ViewBuilder fileprivate func mButtonHelp(
    _ help: LocalizedStringResource?,
    isDisabled: Bool
  ) -> some View {
    if let help {
      #if os(visionOS)
        self.help(help)
      #else
        if isDisabled {
          self.overlay { Color.clear.contentShape(Rectangle()).help(help) }
        } else {
          self.help(help)
        }
      #endif
    } else {
      self
    }
  }

  @ViewBuilder fileprivate func mButtonColorModifiers(
    _ kind: ButtonKind,
    _ accentColor: Color,
    isHovering: Bool
  ) -> some View {
    switch kind {
    case .primary, .secondary, .text, .textPrimary:
      self.foregroundStyle(kind.colorForeground(accentColor, isHovering: isHovering))
        .tint(kind.colorForeground(accentColor, isHovering: isHovering))
        .background(kind.colorBackground(accentColor, isHovering: isHovering))
    case .automatic: self.tint(kind.colorForeground(accentColor, isHovering: isHovering))
    }
  }

  @ViewBuilder fileprivate func applyMButtonFrame(
    _ buttonDimensions: CGSize,
    width: CGFloat?,
    height: CGFloat?,
    modifier: CGFloat = 0
  ) -> some View {
    let (minWidth, maxWidth): (CGFloat?, CGFloat?) = {
      switch width {
      case .none: return (buttonDimensions.width + modifier, nil)
      case .some(let width) where width.isInfinite: return (0, .infinity)
      case .some(let width): return (width + modifier, width + modifier)
      }
    }()

    let (minHeight, maxHeight): (CGFloat?, CGFloat?) = {
      switch height {
      case .none: return (buttonDimensions.height + modifier, nil)
      case .some(let height) where height.isInfinite: return (0, .infinity)
      case .some(let height): return (height + modifier, height + modifier)
      }
    }()

    frame(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      alignment: .center
    )
  }
}
