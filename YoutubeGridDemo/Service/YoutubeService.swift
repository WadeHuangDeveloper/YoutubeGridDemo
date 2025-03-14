//
//  YoutubeService.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation

class YoutubeService {
    static let shared = YoutubeService()
    
    private init() {}
    
    func search(query: String) async throws -> YoutubeServiceSearchResult {
        guard let url = Youtube.API.GetSearchURL(query: query, maxResults: 50) else {
            throw HTTPServiceError.invalidURL
        }
        let response: YoutubeServiceSearchResponse = try await HTTPService.shared.get(apiKey: Youtube.APIKey, url: url)
        return YoutubeServiceSearchResult(videos: response.items)
    }
}
