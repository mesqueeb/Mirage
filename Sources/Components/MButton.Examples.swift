import SwiftUI

fileprivate enum OperatingSystem: String, Codable, Sendable { case visionOS, macOS, iOS }

#if os(visionOS)
  fileprivate let OS = OperatingSystem.visionOS
#elseif os(macOS)
  fileprivate let OS = OperatingSystem.macOS
#elseif os(iOS)
  fileprivate let OS = OperatingSystem.iOS
#endif

fileprivate let sharePlayButtonSizeModifier: CGFloat =
  switch OS {
  case .visionOS: 1.5
  case .iOS: 1
  case .macOS: 1
  }

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
    // swift-format-ignore
    VStack(spacing: Space.md) {
      HStack(spacing: Space.md) {
        ForEach(icons[0 ..< 6], id: \.self) { icon in
          MButton(action: action, iconOnly: true, kind: kind, label: "click me", icon: icon, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled, tint: tint)
        }
      }
      HStack(spacing: Space.md) {
        ForEach(icons[6 ..< icons.count], id: \.self) { icon in
          MButton(action: action, iconOnly: true, kind: kind, label: "click me", icon: icon, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled, tint: tint)
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

  @State var popoverShown = false

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

      // swift-format-ignore
      GridRow {
        Text("Primary")
        VStack {
          MButton(action: onTap,kind: .primary,label: "click me",icon: "play.fill",isActive: isActive,isBusy: isBusy,isDisabled: isDisabled)
          MButton(action: onTap,kind: .primary,label: "click me",isActive: isActive,isBusy: isBusy,isDisabled: isDisabled)
          MButton(action: onTap,kind: .primary,icon: "play.fill",isActive: isActive,isBusy: isBusy,isDisabled: isDisabled)
        }
        VStack {
          MButton(action: onTap, kind: .primary, label: "click me", icon: "play.fill", isBusy: true)
          MButton(action: onTap, kind: .primary, label: "click me", isBusy: true)
          MButton(action: onTap, kind: .primary, icon: "play.fill", isBusy: true)
        }
        VStack {
          MButton(action: onTap, kind: .primary, label: "click me", icon: "play.fill", isActive: true)
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true)
          MButton(action: onTap, kind: .primary, icon: "play.fill", isActive: true)
        }
        VStack {
          MButton(action: onTap, kind: .primary, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .primary, icon: "play.fill", tint: .green)
        }
        VStack {
          MButton(action: onTap, kind: .primary, label: "Submit uploaded files and folder to server", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
            .frame(maxWidth: 240)
          MButton(action: onTap, kind: .primary, label: "Submit uploaded files and folder to server", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
            .frame(maxWidth: 240)
        }
      }

      // swift-format-ignore
      GridRow {
        Text("Secondary")
        VStack {
          MButton(action: onTap, label: "click me", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          MButton(action: onTap, label: "click me", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          MButton(action: onTap, icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
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
          MButton(action: onTap, label: "Submit uploaded files and folder to server", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
            .frame(maxWidth: 240)
          MButton(action: onTap, label: "Submit uploaded files and folder to server", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
            .frame(maxWidth: 240)
        }
      }

      // swift-format-ignore
      GridRow {
        Text("Text")
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          MButton(action: onTap, kind: .text, label: "click me", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          MButton(action: onTap, kind: .text, icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", isBusy: true)
          MButton(action: onTap, kind: .text, label: "click me", isBusy: true)
          MButton(action: onTap, kind: .text, icon: "play.fill", isBusy: true)
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", isActive: true)
          MButton(action: onTap, kind: .text, label: "click me", isActive: true)
          MButton(action: onTap, kind: .text, icon: "play.fill", isActive: true)
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, kind: .text, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .text, icon: "play.fill", tint: .green)
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "Submit uploaded files and folder to server", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          .frame(maxWidth: 240)
          MButton(action: onTap, kind: .text, label: "Submit uploaded files and folder to server", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          .frame(maxWidth: 240)
        }
      }

      GridRow { MHorizontalRule().frame(height: 24).gridCellColumns(6) }

      // swift-format-ignore
      GridRow {
        Text("Automatic")
        VStack(spacing: Space.md) {
          MButton(action: onTap, kind: .automatic, label: "click me", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
        }
        VStack(spacing: Space.md) {
          MButton(action: onTap, kind: .automatic, label: "click me", icon: "play.fill", isBusy: true)
          MButton(action: onTap, kind: .automatic, label: "click me", isBusy: true)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", isBusy: true)
        }
        VStack(spacing: Space.md) {
          MButton(action: onTap, kind: .automatic, label: "click me", icon: "play.fill", isActive: true)
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: true)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", isActive: true)
        }
        VStack(spacing: Space.md) {
          MButton(action: onTap, kind: .automatic, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .automatic, icon: "play.fill", tint: .green)
        }
        VStack(spacing: Space.md) {
          MButton(action: onTap, kind: .automatic, label: "Submit uploaded files and folder to server", icon: "play.fill", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          .frame(maxWidth: 240)
          MButton(action: onTap, kind: .automatic, label: "Submit uploaded files and folder to server", isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
          .frame(maxWidth: 240)
        }
      }
    }

    MHorizontalRule()

    // swift-format-ignore
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
        IconButtonRow(icons: icons, action: onTap, kind: .primary, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
        IconButtonRow(icons: icons, action: onTap, kind: .primary, isBusy: true)
        IconButtonRow(icons: icons, action: onTap, kind: .primary, isActive: true)
        IconButtonRow(icons: icons, action: onTap, kind: .primary, tint: .green)
      }
      GridRow {
        Text("Secondary")
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, isBusy: true)
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, isActive: true)
        IconButtonRow(icons: icons, action: onTap, kind: .secondary, tint: .green)
      }
      GridRow {
        Text("Text")
        IconButtonRow(icons: icons, action: onTap, kind: .text, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
        IconButtonRow(icons: icons, action: onTap, kind: .text, isBusy: true)
        IconButtonRow(icons: icons, action: onTap, kind: .text, isActive: true)
        IconButtonRow(icons: icons, action: onTap, kind: .text, tint: .green)
      }
      GridRow { MHorizontalRule().frame(height: 24).gridCellColumns(6) }
      GridRow {
        Text("Automatic")
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, isActive: isActive, isBusy: isBusy, isDisabled: isDisabled)
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, isBusy: true)
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, isActive: true)
        IconButtonRow(icons: icons, action: onTap, kind: .automatic, tint: .green)
      }
    }

    MHorizontalRule()

    Text("Width")

    VStack(spacing: Space.md) {
      MButton(action: onTap, label: "Regular Button")  // this button will have its default minWidth applied
      MButton(action: onTap, label: "Fixed at 500px width Button", width: 500)  // this button will be 500px wide
      MButton(action: onTap, label: "Full width Button", width: .infinity)  // this button will grow until its parent frame
    }
    .frame(width: 600).border(.brown, width: 1).padding()

    VStack(spacing: Space.md) {
      MButton(action: onTap, label: "Regular Button")  // this button will extrude
      MButton(action: onTap, label: "Fixed at 500px width Button", width: 500)  // this button will extrude
      MButton(action: onTap, label: "Full width Button", width: .infinity)  // this button will shrink until its parent frame
    }
    .frame(width: 70).border(.brown, width: 1).padding()

    MHorizontalRule()

    Text("Height")

    HStack(spacing: Space.md) {
      MButton(action: onTap, label: "Regular Button")  // this button will have its default height applied
      MButton(action: onTap, label: "Fixed at 40px", height: 40)  // this button will have its height fixed at 40px
      MButton(action: onTap, label: "Full height Button", height: .infinity)  // this button will grow until its parent frame
    }
    .frame(height: 60).border(.brown, width: 1).padding()

    HStack(spacing: Space.md) {
      MButton(action: onTap, label: "Regular Button")  // this button will have its default height applied
      MButton(action: onTap, label: "Fixed at 40px", height: 40)  // this button will have its height fixed at 40px
      MButton(action: onTap, label: "Full height Button", height: .infinity)  // this button will shrink until its parent frame
    }
    .frame(height: 10).border(.brown, width: 1).padding()

    MButton(
      action: { popoverShown.toggle() },
      label: "Tap to see Popover",
      width: .infinity,
      height: 48
    )
    .popover(isPresented: $popoverShown) {
      VStack(spacing: Space.md) {
        Text("Sharing MirageDesert").font(.title3).fontWeight(.semibold)

        MHorizontalRule().opacity(0.33)

        VStack(spacing: Space.sm) {
          MButton(
            action: onTap,
            kind: .secondary,
            label: "End for Everyone",
            width: .infinity,
            height: 48 * sharePlayButtonSizeModifier
          )
          .fontWeight(.semibold)
          MButton(
            action: onTap,
            kind: .secondary,
            label: "End Only for Me",
            width: .infinity,
            height: 48 * sharePlayButtonSizeModifier
          )
          .fontWeight(.semibold)
        }
      }
      .padding()
    }

    MHorizontalRule()

    Text("Slot")

    HStack(spacing: Space.md) {
      MButton(action: onTap, label: "SharePlay", icon: "shareplay", isActive: true, tint: .green) {
        Image(systemName: "chevron.right").opacity(0.6)
      }
      MButton(action: onTap, label: "SharePlay", icon: "shareplay", isActive: true, tint: .green)
    }

  }
}
