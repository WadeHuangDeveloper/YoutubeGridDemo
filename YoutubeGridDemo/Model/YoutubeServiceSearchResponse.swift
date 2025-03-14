//
//  YoutubeServiceSearchResponse.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation

struct YoutubeServiceSearchResponse: Codable {
    let items: [YoutubeServiceItem]
}

struct YoutubeServiceItem: Codable {
    let id: YoutubeServiceID
    let snippet: YoutubeServiceSnippet
}

struct YoutubeServiceID: Codable {
    let videoId: String
}

struct YoutubeServiceSnippet: Codable {
    let title: String
    let description: String
    let thumbnails: YoutubeServiceThumbnails
}

struct YoutubeServiceThumbnails: Codable {
    let `default`: YoutubeServiceThumbnailsURL
    let medium: YoutubeServiceThumbnailsURL
    let high: YoutubeServiceThumbnailsURL
}

struct YoutubeServiceThumbnailsURL: Codable {
    let url: String
}
