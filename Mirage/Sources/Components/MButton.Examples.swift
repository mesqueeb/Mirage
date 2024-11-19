import SwiftUI

public struct MButton_Examples: View {
  let onTap: () -> Void

  public init(onTap: @escaping () -> Void) { self.onTap = onTap }

  @State var isActive = false
  @State var isBusy = false
  @State var isDisabled = false

  public var body: some View {
    Grid {
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
          MButton(action: onTap, kind: .primary, label: "click me", icon: "play.fill", isBusy: true)
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
          MButton(action: onTap, kind: .primary, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .primary, icon: "play.fill", tint: .green)
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
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", isActive: true)
          MButton(action: onTap, kind: .text, label: "click me", isActive: true)
          MButton(action: onTap, kind: .text, icon: "play.fill", isActive: true)
        }
        VStack {
          MButton(action: onTap, kind: .text, label: "click me", icon: "play.fill", tint: .green)
          MButton(action: onTap, kind: .text, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, kind: .text, icon: "play.fill", tint: .green)
        }
      }
      GridRow { Spacer(minLength: Space.xxs) }
      GridRow {
        Text("Automatic")
        VStack(spacing: Space.sm) {
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
        VStack(spacing: Space.sm) {
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
        VStack(spacing: Space.sm) {
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
        VStack(spacing: Space.sm) {
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
      }
    }
  }
}
