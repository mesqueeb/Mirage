import SwiftUI

#Preview(traits: .sizeThatFitsLayout) {
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
  }
  .padding()

  #if os(visionOS)
    .glassBackgroundEffect()
  #endif
}
