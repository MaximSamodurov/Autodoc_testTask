//
//  ErrorHandling.swift
//  Autodoc_testTask
//
//  Created by Fixed on 09.12.24.
//

import Foundation

enum ErrorHandling: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was invalid, please try again later"
        case .serverError:
            return "There was an error with the server. Please try again later"
        case .invalidData:
            return "Data is invalid. Please try again later"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
