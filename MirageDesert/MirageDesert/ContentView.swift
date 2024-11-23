import SwiftUI
import Mirage
import AVFoundation

public enum MirageComponent: String, Codable, CaseIterable, Identifiable, Hashable {
  case MButton, MActionButtons, MLink, MHorizontalRule, Typography

  public var id: String { self.rawValue }
}

struct MaybeScrollView<Content: View>: View {
  private let useScrollView: Bool
  private let content: Content
  public init(useScrollView: Bool, @ViewBuilder content: @escaping () -> Content) {
    self.useScrollView = useScrollView
    self.content = content()
  }
  public var body: some View {
    if useScrollView { ScrollView([.horizontal, .vertical]) { content } } else { content }
  }
}

struct ContentView: View {
  // Keep an audio player instance alive for the sound
  @State private var playerMouseClick: AVAudioPlayer?

  func playMouseClick() {
    guard let url = Bundle.main.url(forResource: "mouseclick", withExtension: "wav") else {
      print("Mouse click sound file not found!")
      return
    }
    do {
      playerMouseClick = try AVAudioPlayer(contentsOf: url)
      playerMouseClick?.play()
    } catch { print("Failed to play sound: \(error.localizedDescription)") }
  }

  @State private var component: MirageComponent? = .MButton
  @State private var useScrollView: Bool = false

  var body: some View {
    TabView {
      Tab("Components", systemImage: "square.grid.2x2") {
        NavigationSplitView {
          Toggle("ScrollView", isOn: $useScrollView).padding(.bottom, Space.md)
          List(MirageComponent.allCases, id: \.self, selection: $component) { component in
            Text(component.rawValue)
          }
        } detail: {
          MaybeScrollView(useScrollView: useScrollView) {
            VStack {
              switch component {
              case .MButton: MButton_Examples(onTap: playMouseClick)
              case .MActionButtons: MActionButtons_Examples(onTap: playMouseClick)
              case .MLink: MLink_Examples()
              case .MHorizontalRule: MHorizontalRule_Examples()
              case .Typography: Typography_Examples()
              case .none: Text("Select a component to see examples")
              }
            }
            .padding()
          }
        }
      }
    }
  }
}

#Preview { ContentView() }
