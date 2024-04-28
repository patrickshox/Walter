//
//  URL+Extensions.swift
//  Walter
//
//  Created by Patrick Botros on 4/24/24.
//

import Foundation

extension URL {
  static let accessibilitySettingsURI = URL(
    string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
  )!
}
