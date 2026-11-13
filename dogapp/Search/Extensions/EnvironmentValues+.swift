//
//  EnvironmentValues+.swift
//
//

import SwiftUI

extension EnvironmentValues {
    @Entry var navigateTo: (Destination) -> Void = { _ in }
}
