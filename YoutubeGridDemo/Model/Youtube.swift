//
//  HTTPServiceModel.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation

struct Youtube {
    static let APIKey = ""
    
    struct API {
        private static let Host = "https://www.googleapis.com/youtube/v3/search"
        
        static func GetSearchURL(query: String, maxResults: Int) -> URL? {
            var components = URLComponents(string: Host)
            components?.queryItems = [
                URLQueryItem(name: "part", value: "snippet"),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "type", value: "video"),
                URLQueryItem(name: "maxResults", value: "\(maxResults)"),
                URLQueryItem(name: "key", value: APIKey),
                URLQueryItem(name: "order", value: "viewCount")
            ]
            return components?.url
        }
    }
}
