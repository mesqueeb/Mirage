import SwiftUI

/// A helper subview that generates a row of icon-only MButtons from a given icon array.
struct IconButtonRow: View {
  let icons: [String]
  let action: () -> Void
  let kind: ButtonKind
  let isActive: Bool
  let isBusy: Bool
  let isDisabled: Bool
  let tint: Color?

  init(
    icons: [String],
    action: @escaping () -> Void,
    kind: ButtonKind = .primary,
    isActive: Bool = false,
    isBusy: Bool = false,
    isDisabled: Bool = false,
    tint: Color? = nil
  ) {
    self.icons = icons
    self.action = action
    self.kind = kind
    self.isActive = isActive
    self.isBusy = isBusy
    self.isDisabled = isDisabled
    self.tint = tint
  }

  var body: some View {
    VStack(spacing: Space.md) {
      HStack(spacing: Space.md) {
        ForEach(icons[0 ..< 6], id: \.self) { icon in
          MButton(
            action: action,
            iconOnly: true,
            kind: kind,
            label: "click me",
            icon: icon,
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled,
            tint: tint
          )
        }
      }
      HStack(spacing: Space.md) {
        ForEach(icons[6 ..< icons.count], id: \.self) { icon in
          MButton(
            action: action,
            iconOnly: true,
            kind: kind,
            label: "click me",
            icon: icon,
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled,
            tint: tint
          )
        }
      }
    }
  }
}

public struct MButton_Examples: View {
  let onTap: () -> Void

  public init(onTap: @escaping () -> Void) { self.onTap = onTap }

  @State var isActive = false
  @State var isBusy = false
  @State var isDisabled = false

  let icons: [String] = [
    "xmark", "house.fill", "plus", "trash", "pencil", "heart", "gear", "magnifyingglass", "star",
    "bookmark", "square.and.arrow.up", "ellipsis",
  ]

  public var body: some View {
    Grid(horizontalSpacing: Space.md) {
      GridRow {
        VStack {
          Toggle("Active", isOn: $isActive)
          Toggle("Busy", isOn: $isBusy)
          Toggle("Disabled", isOn: $isDisabled)
        }
        .gridCellColumns(2)
        Text("isBusy")
        Text("isActive")
        Text("tint")
        Text("long label")
      }
      GridRow {
        Text("Primary")
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            kind: .primary,
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            icon: "play.fill",
            isBusy: true
          )
          MButton(action: onTap, kind: .primary, label: "click me", isBusy: true)
          MButton(action: onTap, kind: .primary, icon: "play.fill", isBusy: true)
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            icon: "play.fill",
            isActive: true
          )
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true)
          MButton(action: onTap, kind: .primary, icon: "play.fill", isActive: true)
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            icon: "play.fill",
            tint: .green
          )
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .primary, icon: "play.fill", tint: .green)
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "Submit uploaded files and folder to server",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
          MButton(
            action: onTap,
            kind: .primary,
            label: "Submit uploaded files and folder to server",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
        }
      }
      GridRow {
        Text("Secondary")
        VStack {
          MButton(
            action: onTap,
            label: "click me",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            label: "click me",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
        }
        VStack {
          MButton(action: onTap, label: "click me", icon: "play.fill", isBusy: true)
          MButton(action: onTap, label: "click me", isBusy: true)
          MButton(action: onTap, icon: "play.fill", isBusy: true)
        }
        VStack {
          MButton(action: onTap, label: "click me", icon: "play.fill", isActive: true)
          MButton(action: onTap, label: "click me", isActive: true)
          MButton(action: onTap, icon: "play.fill", isActive: true)
        }
        VStack {
          MButton(action: onTap, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, icon: "play.fill", tint: .green)
        }
        VStack {
          MButton(
            action: onTap,
            label: "Submit uploaded files and folder to server",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
          MButton(
            action: onTap,
            label: "Submit uploaded files and folder to server",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
        }
      }
      GridRow {
        Text("Text")
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "click me",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            kind: .text,
            label: "click me",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            kind: .text,
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", isBusy: true)
          MButton(action: onTap, kind: .text, label: "click me", isBusy: true)
          MButton(action: onTap, kind: .text, icon: "play.fill", isBusy: true)
        }
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "click me",
            icon: "play.fill",
            isActive: true
          )
          MButton(action: onTap, kind: .text, label: "click me", isActive: true)
          MButton(action: onTap, kind: .text, icon: "play.fill", isActive: true)
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, kind: .text, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .text, icon: "play.fill", tint: .green)
        }
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "Submit uploaded files and folder to server",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
          MButton(
            action: onTap,
            kind: .text,
            label: "Submit uploaded files and folder to server",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
        }
      }
      GridRow { MHorizontalRule(width: .infinity).frame(height: 24).gridCellColumns(6) }
      GridRow {
        Text("Automatic")
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          MButton(
            action: onTap,
            kind: .automatic,
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            icon: "play.fill",
            isBusy: true
          )
          MButton(action: onTap, kind: .automatic, label: "click me", isBusy: true)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", isBusy: true)
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            icon: "play.fill",
            isActive: true
          )
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: true)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", isActive: true)
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            icon: "play.fill",
            tint: .green
          )
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", tint: .green)
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "Submit uploaded files and folder to server",
            icon: "play.fill",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
          MButton(
            action: onTap,
            kind: .automatic,
            label: "Submit uploaded files and folder to server",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
          .frame(maxWidth: 240)
        }
      }
    }

    MHorizontalRule(width: .infinity)

    Grid(horizontalSpacing: Space.md) {
      GridRow {
        VStack {
          Toggle("Active", isOn: $isActive)
          Toggle("Busy", isOn: $isBusy)
          Toggle("Disabled", isOn: $isDisabled)
        }
        .gridCellColumns(2)
        Text("isBusy")
        Text("isActive")
        Text("tint")
        Text("long label")
      }
      GridRow {
        Text("Primary")  // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .primary, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .primary, isBusy: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .primary, isActive: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .primary, tint: .green) // swift-format-ignore
      }
      GridRow {
        Text("Secondary")  // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, isBusy: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, isActive: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, tint: .green) // swift-format-ignore
      }
      GridRow {
        Text("Text")  // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .text, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .text, isBusy: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .text, isActive: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .text, tint: .green) // swift-format-ignore
      }
      GridRow { MHorizontalRule(width: .infinity).frame(height: 24).gridCellColumns(6) }
      GridRow {
        Text("Automatic")  // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, isBusy: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, isActive: true) // swift-format-ignore
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, tint: .green) // swift-format-ignore
      }
    }
  }
}
