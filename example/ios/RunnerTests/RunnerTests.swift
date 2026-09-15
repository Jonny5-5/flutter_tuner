import Flutter
import UIKit
import XCTest


@testable import flutter_tuner

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testUnknownMethodIsNotImplemented() {
    let plugin = FlutterTunerPlugin()

    let call = FlutterMethodCall(methodName: "notAPluginMethod", arguments: nil)

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue((result as? NSObject) === FlutterMethodNotImplemented)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}
