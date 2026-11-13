//
//  API.swift
//
//

import Foundation

extension DogCeo {
    enum API {}
}

extension DogCeo.API {
    nonisolated enum Error: String, Swift.Error, LocalizedError {
        case failedToFetch
        
        var errorDescription: String? {
            switch self {
            case .failedToFetch:
                return "Failed to fetch Poochies. Please, try again."
            }
        }
    }
    
    nonisolated enum Status: String, Decodable {
        case success
        case error
        
        var isSuccess: Bool {
            self == .success
        }
    }
    
    nonisolated struct Response<Message: Decodable>: Decodable {
        let message: Message
        
        private enum CodingKeys: String, CodingKey {
            case message
            case status
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let status = try container.decode(Status.self, forKey: .status)
            
            guard status.isSuccess else {
                throw Error.failedToFetch
            }
            
            self.message = try container.decode(Message.self, forKey: .message)
        }
    }
}

