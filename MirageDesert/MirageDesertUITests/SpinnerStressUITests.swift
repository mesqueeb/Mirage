import XCTest

final class SpinnerStressUITests: XCTestCase {
  func testSpinnerKeepsAnimatingWithoutStarvingMainActorWork() {
    let app = XCUIApplication()
    app.launchArguments.append("--spinner-stress-demo")
    app.launch()

    let button = app.buttons["spinner-stress-button"]
    XCTAssertTrue(button.waitForExistence(timeout: 5))

    button.click()

    var spinnerFrames: Set<Data> = []
    for _ in 0 ..< 10 {
      spinnerFrames.insert(button.screenshot().pngRepresentation)
      Thread.sleep(forTimeInterval: 0.2)
    }

    XCTAssertGreaterThan(
      spinnerFrames.count,
      3,
      "The spinner stopped presenting new frames while the MainActor was under pressure"
    )
    XCTAssertTrue(
      app.staticTexts["Completed runs: 1"].waitForExistence(timeout: 12),
      "The spinner starved a fixed ten-second MainActor workload"
    )
  }
}
