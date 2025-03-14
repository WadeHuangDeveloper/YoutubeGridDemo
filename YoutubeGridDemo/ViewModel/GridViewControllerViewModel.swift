//
//  GridViewControllerViewModel.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation
import UIKit
import Combine

class GridViewControllerViewModel {
    var gridItemsSubject = CurrentValueSubject<[YoutubeGridItem], Never>([])
    
    init() {
        
    }
    
    func search(query: String) async throws {
        let result = try await YoutubeService.shared.search(query: query)
        var videos = [YoutubeGridItem]()
        
        try await withThrowingTaskGroup(of: YoutubeGridItem.self) { group in
            for video in result.videos {
                group.addTask {
                    let url = URL(string: video.snippet.thumbnails.high.url)!
                    let image = try await HTTPService.shared.download(from: url)
                    let item = YoutubeGridItem(serviceItem: video, thumbnail: image)
                    return item
                }
            }
            for try await item in group {
                videos.append(item)
            }
        }
        gridItemsSubject.send(videos)
    }
}
