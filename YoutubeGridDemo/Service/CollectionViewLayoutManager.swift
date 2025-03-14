//
//  CollectionViewLayoutManager.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import Foundation
import UIKit

class CollectionViewLayoutManager {
    static let shared = CollectionViewLayoutManager()
    
    private init() {}
    
    // MARK: - Size
    
    private static func getShortItemSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                      heightDimension: .fractionalWidth(2/3)
        )
    }
    
    private static func getVideoItemSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(1/2))
    }
    
    private static func getVerticalGroupSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                      heightDimension: .fractionalHeight(1))
    }
    
    private static func getHorizontalGroupSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(1/2))
    }
    
    private static func getCombineGroupSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalWidth(4/3))
    }
    
    // MARK: - Group
    
    private static func getVerticalGroup(item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.vertical(layoutSize: getVerticalGroupSize(),
                                                repeatingSubitem: item,
                                                count: 2)
    }
    
    private static func getHorizontalGroup(leftItem: NSCollectionLayoutItem, middleItem: NSCollectionLayoutItem, rightItem: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(layoutSize: getHorizontalGroupSize(),
                                                  subitems: [leftItem, middleItem, rightItem])
    }
    
    private static func getCombineGroup() -> NSCollectionLayoutGroup {
        let shortItemSize = getShortItemSize()
        let shortItem = NSCollectionLayoutItem(layoutSize: shortItemSize)
        
        let videoItemSize = getVideoItemSize()
        let videoItem = NSCollectionLayoutItem(layoutSize: videoItemSize)
        
        let verticalGroup = getVerticalGroup(item: videoItem)
        verticalGroup.interItemSpacing = .fixed(1)
        
        let topGroup = getHorizontalGroup(leftItem: shortItem, middleItem: verticalGroup, rightItem: verticalGroup)
        topGroup.interItemSpacing = .fixed(1)
        
        let bottomGroup = getHorizontalGroup(leftItem: verticalGroup, middleItem: verticalGroup, rightItem: shortItem)
        bottomGroup.interItemSpacing = .fixed(1)
        
        let combineGroupSize = getCombineGroupSize()
        return NSCollectionLayoutGroup.vertical(layoutSize: combineGroupSize, subitems: [topGroup, bottomGroup])
    }
    
    // MARK: - Section
    
    private static func getSection() -> NSCollectionLayoutSection {
        let group = getCombineGroup()
        group.interItemSpacing = .fixed(1)
        return NSCollectionLayoutSection(group: group)
    }
    
    // MARK: - Layout
    
    static func CreateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let section = getSection()
        section.interGroupSpacing = 2
        return UICollectionViewCompositionalLayout(section: section)
    }
}
