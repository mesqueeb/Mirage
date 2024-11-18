import SwiftUI
import Mirage
import AVFoundation

struct ContentView: View {
  // Keep an audio player instance alive for the sound
  @State private var playerMouseClick: AVAudioPlayer?

  func playMouseClick() {
    guard let url = Bundle.main.url(forResource: "mouseclick", withExtension: "wav") else {
      print("Mouse click sound file not found!")
      return
    }
    do {
      if playerMouseClick == nil { playerMouseClick = try AVAudioPlayer(contentsOf: url) }
      playerMouseClick?.play()
    } catch { print("Failed to play sound: \(error.localizedDescription)") }
  }

  var body: some View {
    TabView {
      Tab("Components", systemImage: "square.grid.2x2") { MButtonExamples(onTap: playMouseClick) }
    }
  }
}

#Preview { ContentView() }
