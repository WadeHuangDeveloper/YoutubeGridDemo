//
//  HTTPServiceError.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation

enum HTTPServiceError: Error {
    case invalidURL
    case invalidAPIKey
    case invalidError(Error)
    case downloadFailed
}
