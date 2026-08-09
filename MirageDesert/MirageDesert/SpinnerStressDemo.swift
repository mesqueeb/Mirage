import Mirage
import RealityKit
import SwiftUI

struct SpinnerStressDemo: View {
  @State private var scene = RealityKitStressScene()
  @State private var isAnimating = false
  @State private var spinnerRuns = 0
  @State private var noSpinnerRuns = 0

  var body: some View {
    VStack(spacing: Space.md) {
      Text("MButton + RealityKit Stress Demo").font(.title)
      Text(
        "Both buttons run the same ten-second RealityKit animation over 840 nested mesh entities, reversing every 2.5 seconds. Compare scene motion with and without MButton's busy spinner."
      )
      .multilineTextAlignment(.center).frame(maxWidth: 680)

      RealityView { content in
        scene.build()
        content.add(scene.root)
        #if !os(visionOS)
          content.camera = .virtual
        #endif
      }
      .frame(minWidth: 760, minHeight: 420).background(.black)
      .clipShape(RoundedRectangle(cornerRadius: 16))

      HStack(spacing: Space.xl) {
        VStack(spacing: Space.sm) {
          Text("Async MButton").font(.headline)
          MButton(
            action: animateWithSpinner,
            kind: .primary,
            label: "Animate with spinner",
            icon: "crop",
            isDisabled: isAnimating
          )
          .accessibilityIdentifier("spinner-stress-button")
          Text("Completed runs: \(spinnerRuns)")
            .accessibilityIdentifier("spinner-stress-completed-runs")
        }

        VStack(spacing: Space.sm) {
          Text("Synchronous MButton").font(.headline)
          MButton(
            action: { Task { await animateWithoutSpinner() } },
            kind: .primary,
            label: "Animate without spinner",
            icon: "crop",
            isDisabled: isAnimating
          )
          Text("Completed runs: \(noSpinnerRuns)")
        }
      }
    }
    .padding(32).frame(minWidth: 900, minHeight: 700)
  }

  @MainActor private func animateWithSpinner() async {
    guard !isAnimating else { return }
    isAnimating = true
    await runStressAnimation()
    spinnerRuns += 1
    isAnimating = false
  }

  @MainActor private func animateWithoutSpinner() async {
    guard !isAnimating else { return }
    isAnimating = true
    await runStressAnimation()
    noSpinnerRuns += 1
    isAnimating = false
  }

  @MainActor private func runStressAnimation() async {
    for _ in 0 ..< 4 {
      scene.animate(duration: 2.5)
      try? await Task.sleep(for: .seconds(2.5))
    }
  }
}

@MainActor private final class RealityKitStressScene {
  let root = Entity()
  private var groups: [Entity] = []
  private var isBuilt = false
  private var isExpanded = false

  func build() {
    guard !isBuilt else { return }
    isBuilt = true

    let mesh = MeshResource.generateBox(size: [0.018, 0.026, 0.002])
    let material = UnlitMaterial()

    for groupIndex in 0 ..< 6 {
      let group = Entity()
      group.position = position(for: groupIndex, expanded: false)
      root.addChild(group)
      groups.append(group)

      for stackIndex in 0 ..< 5 {
        let stack = Entity()
        stack.position.x = Float(stackIndex - 2) * 0.055
        group.addChild(stack)

        for cardIndex in 0 ..< 7 {
          let card = Entity()
          card.position = [0, Float(cardIndex - 3) * 0.035, Float(cardIndex) * 0.001]
          stack.addChild(card)

          for meshIndex in 0 ..< 4 {
            let model = ModelEntity(mesh: mesh, materials: [material])
            let x: Float = meshIndex.isMultiple(of: 2) ? -0.01 : 0.01
            let y: Float = meshIndex < 2 ? -0.014 : 0.014
            model.position = [x, y, Float(meshIndex) * 0.0002]
            card.addChild(model)
          }
        }
      }
    }

    let camera = PerspectiveCamera()
    camera.position = [0, 0, 1.6]
    camera.look(at: .zero, from: camera.position, relativeTo: nil)
    root.addChild(camera)
  }

  func animate(duration: TimeInterval) {
    isExpanded.toggle()
    for (index, group) in groups.enumerated() {
      var target = group.transform
      target.translation = position(for: index, expanded: isExpanded)
      target.rotation = simd_quatf(
        angle: isExpanded ? Float(index - 3) * 0.16 : 0,
        axis: [0, 0, 1]
      )
      group.move(
        to: target,
        relativeTo: group.parent,
        duration: duration,
        timingFunction: .easeInOut
      )
    }
  }

  private func position(for index: Int, expanded: Bool) -> SIMD3<Float> {
    let angle = Float(index) / 6 * .pi * 2
    let radius: Float = expanded ? 0.47 : 0.22
    return [cos(angle) * radius, sin(angle) * radius, 0]
  }
}
