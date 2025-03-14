//
//  HTTPService.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation
import Alamofire
import UIKit

class HTTPService {
    static let shared = HTTPService()
    
    private init() {}
    
    func get<T: Codable>(apiKey: String, url: URL) async throws -> T {
        guard !apiKey.isEmpty else {
            throw HTTPServiceError.invalidAPIKey
        }
        let response = await AF.request(url, method: .get)
            .serializingDecodable(T.self)
            .response
        switch response.result {
        case .success(let result):
            return result
        case .failure(let error):
            print("\(Self.self) \(#function) error: \(error.localizedDescription)")
            throw HTTPServiceError.invalidError(error)
        }
    }
    
    func download(from url: URL) async throws -> UIImage {
        let response = await AF.download(url)
            .serializingData()
            .response
        switch response.result {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                throw HTTPServiceError.downloadFailed
            }
            return image
        case .failure(let error):
            print("\(Self.self) \(#function) error: \(error.localizedDescription)")
            throw HTTPServiceError.invalidError(error)
        }
    }
}
