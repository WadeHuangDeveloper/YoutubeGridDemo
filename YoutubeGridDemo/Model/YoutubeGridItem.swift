//
//  YoutubeGridItem.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/14.
//

import Foundation
import UIKit

struct YoutubeGridItem {
    var serviceItem: YoutubeServiceItem
    var thumbnail: UIImage
    
    init(serviceItem: YoutubeServiceItem, thumbnail: UIImage) {
        self.serviceItem = serviceItem
        self.thumbnail = thumbnail
    }
}
