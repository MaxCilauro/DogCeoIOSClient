//
//  ImageLoadPhase.swift
//
//

import UIKit

enum ImageLoadPhase {
    case loading
    case failed(error: Error, retry: () -> Void)
    case loaded(UIImage)
}
