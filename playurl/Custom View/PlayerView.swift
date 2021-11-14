//
//  PlayerView.swift
//  playurl
//
//  Created by ENFINY INNOVATIONS on 11/14/21.
//

import UIKit
import AVKit


class PlayerView: UIView {
    
    private lazy var playerViewController: AVPlayerViewController = {
        let controller = AVPlayerViewController()
        controller.allowsPictureInPicturePlayback = true
        controller.videoGravity = .resizeAspectFill
        controller.canStartPictureInPictureAutomaticallyFromInline = true
        return controller
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configurePlayer()
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func configurePlayer() {
   
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        
      
        addSubview(playerViewController.view)
    
        
    }

}
