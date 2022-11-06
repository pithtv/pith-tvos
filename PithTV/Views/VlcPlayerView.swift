//
//  VlcPlayerView.swift
//  PithTV
//
//  Created by Christoph Cantillon on 03/11/2022.
//

import SwiftUI
import AVFoundation

class VlcPlayerView: UIView, VLCMediaPlayerDelegate, ObservableObject
{
    let mediaPlayer: VLCMediaPlayer

    init(mediaPlayer: VLCMediaPlayer) {
        self.mediaPlayer = mediaPlayer
        super.init(frame: UIScreen.main.bounds)
        
        mediaPlayer.setDeinterlaceFilter(nil)
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
      super.layoutSubviews()
    }
}
