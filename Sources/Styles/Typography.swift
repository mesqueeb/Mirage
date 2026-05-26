import SwiftUI

public struct Typography_Examples: View {
  public init() {}

  public var body: some View {
    VStack(spacing: Space.md) {
      #if os(visionOS)
        VStack { Text("extraLargeTitle").font(.extraLargeTitle) }
        VStack { Text("extraLargeTitle2").font(.extraLargeTitle2) }
      #endif
      VStack { Text("largeTitle").font(.largeTitle) }
      VStack { Text("title").font(.title) }
      VStack { Text("title2").font(.title2) }
      VStack { Text("title3").font(.title3) }
      VStack {
        Text("headline").font(.headline)
        Text("A font with the headline text style.").font(.headline)
      }
      VStack {
        Text("subheadline").font(.subheadline)
        Text("A font with the subheadline text style.").font(.subheadline)
      }
      VStack {
        Text("body").font(.body)
        Text("A font with the body text style.").font(.body)
      }
      VStack {
        Text("callout").font(.callout)
        Text("A font with the callout text style.").font(.callout)
      }
      VStack {
        Text("caption").font(.caption)
        Text("A font with the caption text style.").font(.caption)
      }
      VStack {
        Text("caption2").font(.caption2)
        Text("Create a font with the alternate caption text style.").font(.caption2)
      }
      VStack {
        Text("footnote").font(.footnote)
        Text("A font with the footnote text style.").font(.footnote)
      }
      Text("Font Weights").font(.largeTitle).padding(.top, Space.md)
      VStack(spacing: Space.sm) {
        Text("A font with the ultraLight fontWeight").fontWeight(.ultraLight)
        Text("A font with the thin       fontWeight").fontWeight(.thin)
        Text("A font with the light      fontWeight").fontWeight(.light)
        Text("A font with the regular    fontWeight").fontWeight(.regular)
        Text("A font with the medium     fontWeight").fontWeight(.medium)
        Text("A font with the semibold   fontWeight").fontWeight(.semibold)
        Text("A font with the bold       fontWeight").fontWeight(.bold)
        Text("A font with the heavy      fontWeight").fontWeight(.heavy)
        Text("A font with the black      fontWeight").fontWeight(.black)
      }
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  Typography_Examples().padding()

    #if os(iOS)
      .padding(.bottom, 350)
    #elseif os(visionOS)
      .glassBackgroundEffect()
    #endif
}
