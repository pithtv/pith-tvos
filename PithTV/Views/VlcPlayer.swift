//
//  VlcPlayer.swift
//  PithTV
//
//  Created by Christoph Cantillon on 05/11/2022.
//

import SwiftUI

struct VlcPlayer: UIViewRepresentable
{
    var player: VLCMediaPlayer
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VlcPlayer>)
    {
    }

    func makeUIView(context: Context) -> UIView
    {
        let playerView = VlcPlayerView(mediaPlayer: player)
        return playerView
    }
}
