//
//  GridCollectionViewCell.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import UIKit
import YouTubeiOSPlayerHelper

class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(GridCollectionViewCell.self)"
    var viewModel = GridCollectionViewCellViewModel()
    private var imageView: UIImageView!
    private lazy var playerView = YTPlayerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        playerView.isHidden = true
        playerView.delegate = self
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(item: YoutubeGridItem?) {
        viewModel.item = item
        imageView.image = item?.thumbnail
        
        let playVars: [String: Any] = [
            "playsinline": 1,
            "autoplay": 0,
            "controls": 0,
            "rel": 0,
            "modestbranding": 1,
            "mute": 1,
        ]
        playerView.load(withVideoId: item!.serviceItem.id.videoId, playerVars: playVars)
    }
    
    func play() {
        playerView.playVideo()
        playerView.isHidden = false
        imageView.isHidden = true
    }
    
    func pause() {
        playerView.pauseVideo()
        playerView.isHidden = true
        imageView.isHidden = false
    }
}

extension GridCollectionViewCell: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        if !playerView.isHidden {
            playerView.playVideo()
        }
    }
}
