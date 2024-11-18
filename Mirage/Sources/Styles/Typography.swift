import SwiftUI

#Preview {
  VStack(spacing: Space.md) {
    #if os(visionOS)
      VStack {
        Text("extraLargeTitle").font(.extraLargeTitle)
        Text("Create a font with the extra large title text style.")
      }
      VStack {
        Text("extraLargeTitle2").font(.extraLargeTitle2)
        Text("Create a font with the second level extra large title text style.")
      }
    #endif
    VStack {
      Text("largeTitle").font(.largeTitle)
      Text("A font with the large title text style.")
    }
    VStack {
      Text("title").font(.title)
      Text("A font with the title text style.")
    }
    VStack {
      Text("title2").font(.title2)
      Text("Create a font for second level hierarchical headings.")
    }
    VStack {
      Text("title3").font(.title3)
      Text("Create a font for third level hierarchical headings.")
    }
    VStack {
      Text("headline").font(.headline)
      Text("A font with the headline text style.")
    }
    VStack {
      Text("subheadline").font(.subheadline)
      Text("A font with the subheadline text style.")
    }
    VStack {
      Text("body").font(.body)
      Text("A font with the body text style.")
    }
    VStack {
      Text("callout").font(.callout)
      Text("A font with the callout text style.")
    }
    VStack {
      Text("caption").font(.caption)
      Text("A font with the caption text style.")
    }
    VStack {
      Text("caption2").font(.caption2)
      Text("Create a font with the alternate caption text style.")
    }
    VStack {
      Text("footnote").font(.footnote)
      Text("A font with the footnote text style.")
    }
  }
}
