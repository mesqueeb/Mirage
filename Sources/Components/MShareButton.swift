import CoreTransferable
import SwiftUI

public struct MShareButton<
  Item: Transferable,
  PreviewImage: Transferable,
  PreviewIcon: Transferable,
  Content: View
>: View {
  let isShown: Bool
  let item: Item
  let subject: Text?
  let message: Text?
  let preview: SharePreview<PreviewImage, PreviewIcon>
  let iconOnly: Bool
  let kind: ButtonKind
  let label: LocalizedStringResource?
  let icon: String?
  let isActive: Bool
  let isDisabled: Bool
  let help: LocalizedStringResource?
  let tint: Color?
  let width: CGFloat?
  let height: CGFloat?
  let extraContent: () -> Content

  public init(
    if isShown: Bool = true,
    item: Item,
    subject: Text? = nil,
    message: Text? = nil,
    preview: SharePreview<PreviewImage, PreviewIcon>,
    iconOnly: Bool = false,
    kind: ButtonKind = .secondary,
    label: LocalizedStringResource? = nil,
    icon: String? = nil,
    isActive: Bool = false,
    isDisabled: Bool = false,
    help: LocalizedStringResource? = nil,
    tint: Color? = nil,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    @ViewBuilder extraContent: @escaping () -> Content = { EmptyView() }
  ) {
    self.isShown = isShown
    self.item = item
    self.subject = subject
    self.message = message
    self.preview = preview
    self.iconOnly = iconOnly
    self.kind = kind
    self.label = label
    self.icon = icon
    self.isActive = isActive
    self.isDisabled = isDisabled
    self.help = help
    self.tint = tint
    self.width = width
    self.height = height
    self.extraContent = extraContent
  }

  @State private var isHovering = false

  private var presentation: MButtonPresentation {
    MButtonPresentation(
      iconOnly: iconOnly,
      kind: kind,
      label: label,
      icon: icon,
      isActive: isActive,
      isBusy: false,
      isDisabled: isDisabled,
      help: help,
      tint: tint,
      width: width,
      height: height
    )
  }

  public var body: some View {
    if isShown {
      ShareLink(item: item, subject: subject, message: message, preview: preview) {
        presentation.label(spinnerRotation: 0, isHovering: isHovering, extraContent: extraContent)
      }
      .disabled(isDisabled).mButtonAppearance(presentation, isHovering: $isHovering)
    } else {
      EmptyView()
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) { MShareButton_Examples().padding() }
