//
//  URLSession+.swift
//
//

import Foundation

nonisolated extension URLSession {
    enum ValidationError: LocalizedError {
        case badStatusCode(Int)

        var errorDescription: String? {
            switch self {
            case .badStatusCode(let code):
                return "The server returned status code \(code)."
            }
        }
    }

    func validatedData(from url: URL) async throws -> Data {
        let (data, response) = try await self.data(from: url)

        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
           !(200..<300).contains(statusCode) {
            throw ValidationError.badStatusCode(statusCode)
        }

        return data
    }
}
