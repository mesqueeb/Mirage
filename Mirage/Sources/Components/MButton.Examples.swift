import SwiftUI

public struct MButton_Examples: View {
  let onTap: () -> Void

  public init(onTap: @escaping () -> Void) { self.onTap = onTap }

  @State var isActive = false
  @State var isBusy = false
  @State var isDisabled = false

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
            icon: "figure.stand",
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
            icon: "figure.stand",
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
            icon: "figure.stand",
            isBusy: true
          )
          MButton(action: onTap, kind: .primary, label: "click me", isBusy: true)
          MButton(
            action: onTap,
            kind: .primary,
            icon: "figure.stand",
            isBusy: true
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            icon: "figure.stand",
            isActive: true
          )
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true)
          MButton(
            action: onTap,
            kind: .primary,
            icon: "figure.stand",
            isActive: true
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "click me",
            icon: "figure.stand",
            tint: .green
          )
          MButton(action: onTap, kind: .primary, label: "click me", isActive: true, tint: .green)
          MButton(
            action: onTap,
            kind: .primary,
            icon: "figure.stand",
            tint: .green
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .primary,
            label: "Submit uploaded files and folder to server",
            icon: "figure.stand",
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
            icon: "figure.stand",
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
            icon: "figure.stand",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
        }
        VStack {
          MButton(
            action: onTap,
            label: "click me",
            icon: "figure.stand",
            isBusy: true
          )
          MButton(action: onTap, label: "click me", isBusy: true)
          MButton(action: onTap, icon: "figure.stand", isBusy: true)
        }
        VStack {
          MButton(
            action: onTap,
            label: "click me",
            icon: "figure.stand",
            isActive: true
          )
          MButton(action: onTap, label: "click me", isActive: true)
          MButton(action: onTap, icon: "figure.stand", isActive: true)
        }
        VStack {
          MButton(
            action: onTap,
            label: "click me",
            icon: "figure.stand",
            tint: .green
          )
          MButton(action: onTap, label: "click me", isActive: true, tint: .green)
          MButton(action: onTap, icon: "figure.stand", tint: .green)
        }
        VStack {
          MButton(
            action: onTap,
            label: "Submit uploaded files and folder to server",
            icon: "figure.stand",
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
            icon: "figure.stand",
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
            icon: "figure.stand",
            isActive: isActive,
            isBusy: isBusy,
            isDisabled: isDisabled
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "click me",
            icon: "figure.stand",
            isBusy: true
          )
          MButton(action: onTap, kind: .text, label: "click me", isBusy: true)
          MButton(
            action: onTap,
            kind: .text,
            icon: "figure.stand",
            isBusy: true
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "click me",
            icon: "figure.stand",
            isActive: true
          )
          MButton(action: onTap, kind: .text, label: "click me", isActive: true)
          MButton(
            action: onTap,
            kind: .text,
            icon: "figure.stand",
            isActive: true
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "click me",
            icon: "figure.stand",
            tint: .green
          )
          MButton(action: onTap, kind: .text, label: "click me", isActive: true, tint: .green)
          MButton(
            action: onTap,
            kind: .text,
            icon: "figure.stand",
            tint: .green
          )
        }
        VStack {
          MButton(
            action: onTap,
            kind: .text,
            label: "Submit uploaded files and folder to server",
            icon: "figure.stand",
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
            icon: "figure.stand",
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
            icon: "figure.stand",
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
            icon: "figure.stand",
            isBusy: true
          )
          MButton(action: onTap, kind: .automatic, label: "click me", isBusy: true)
          MButton(
            action: onTap,
            kind: .automatic,
            icon: "figure.stand",
            isBusy: true
          )
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            icon: "figure.stand",
            isActive: true
          )
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: true)
          MButton(
            action: onTap,
            kind: .automatic,
            icon: "figure.stand",
            isActive: true
          )
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "click me",
            icon: "figure.stand",
            tint: .green
          )
          MButton(action: onTap, kind: .automatic, label: "click me", isActive: true, tint: .green)
          MButton(
            action: onTap,
            kind: .automatic,
            icon: "figure.stand",
            tint: .green
          )
        }
        VStack(spacing: Space.md) {
          MButton(
            action: onTap,
            kind: .automatic,
            label: "Submit uploaded files and folder to server",
            icon: "figure.stand",
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
  }
}
