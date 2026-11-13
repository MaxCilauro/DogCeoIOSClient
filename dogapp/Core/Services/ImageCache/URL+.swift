//
//  URL+.swift
//
//

import Foundation

extension URL {
    func storageKey(for size: CGSize) -> NSString {
        "\(self.absoluteString)|\(size.width)x\(size.height)" as NSString
    }
}
