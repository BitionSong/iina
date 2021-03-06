//
//  DurationDisplayView.swift
//  iina
//
//  Created by Christophe Laprun on 26/01/2017.
//  Copyright © 2017 lhc. All rights reserved.
//

import Foundation

class DurationDisplayTextField: NSTextField {

  enum DisplayMode {
    case current
    case duration // displays the duration of the movie
    case remaining // displays the remaining time in the movie
  }

  var mode: DisplayMode = .duration

  /** Switches the display mode between duration and remaining time */
  func switchMode() {
    guard mode != .current else { return }
    switch mode {
    case .duration:
      mode = .remaining
    default:
      mode = .duration
    }
  }


  func updateText(with duration: VideoTime, given current: VideoTime) {
    let stringValue: String
    switch mode {
    case .current:
      stringValue = current.stringRepresentation
    case .duration:
      stringValue = duration.stringRepresentation
    case .remaining:
      var remaining = (duration - current)
      if remaining.second < 0 {
        remaining = VideoTime.zero
      }
      stringValue = "-\(remaining.stringRepresentation)"
    }
    self.stringValue = stringValue
  }

  override func mouseDown(with event: NSEvent) {
    super.mouseDown(with: event)

    self.switchMode()
    Preference.set(mode == .remaining, for: .showRemainingTime)
  }

  override func touchesBegan(with event: NSEvent) {
    // handles the remaining time text field in the touch bar
    super.touchesBegan(with: event)

    self.switchMode()
    Preference.set(mode == .remaining, for: .touchbarShowRemainingTime)
  }

}
