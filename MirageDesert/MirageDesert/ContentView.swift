import SwiftUI
import Mirage
import AVFoundation

public enum MirageComponent: String, Codable, CaseIterable, Identifiable, Hashable {
  case MButton, MActionButtons, MLink

  public var id: String { self.rawValue }
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

  @State private var component: MirageComponent? = nil

  var body: some View {
    TabView {
      Tab("Components", systemImage: "square.grid.2x2") {
        NavigationSplitView {
          List(MirageComponent.allCases, id: \.self, selection: $component) { component in
            Text(component.rawValue)
          }
        } detail: {
          switch component {
          case .MButton:
            #if !os(visionOS)
              ScrollView([.horizontal, .vertical]) {
                MButton_Examples(onTap: playMouseClick).padding()
              }
            #else
              MButton_Examples(onTap: playMouseClick).padding()
            #endif
          case .MActionButtons: MActionButtons_Examples(onTap: playMouseClick).padding()
          case .MLink: MLink_Examples().padding()
          case .none: Text("Select a component to see examples").padding()
          }
        }
      }
    }
  }
}

#Preview { ContentView() }
