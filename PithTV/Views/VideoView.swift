//
//  VideoView.swift
//  PithTV
//
//  Created by Christoph Cantillon on 05/11/2022.
//

import Foundation
import SwiftUI

class PlayerState : ObservableObject {
    @Published var currentTimeString: String?
    @Published var currentTime: Int32?
    @Published var totalTimeString: String?
    @Published var totalTime: Int32?
    @State var playerTimeChangedNotification: NSObjectProtocol?
    var player: VLCMediaPlayer;
    
    init() {
        self.player = VLCMediaPlayer()
        self.playerTimeChangedNotification = NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: VLCMediaPlayerTimeChanged),
            object: player,
            queue: nil,
            using: self.playerTimeChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(playerTimeChangedNotification as Any)
    }
    
    func playerTimeChanged(_ notification: Notification) {
        self.currentTimeString = player.time.stringValue
        self.currentTime = player.time.intValue
        self.totalTimeString = player.media?.length.stringValue
        self.totalTime = player.media?.length.intValue
    }
}

struct VideoView: View {
    var url: String;
    
    @State var isShowInfoPanel: Bool = true
    
    
    @ObservedObject var state: PlayerState = PlayerState()
    
    func playPauseVideo()
    {
        if(state.player.isPlaying)
        {
            state.player.pause()
            isShowInfoPanel = true
        }
        else
        {
            state.player.play()
            isShowInfoPanel = false
        }
    }
    
    var body: some View {
        
        ZStack
        {
            VlcPlayer(player: state.player)
                .fullScreenCover(isPresented: $isShowInfoPanel)
            {
                VStack {
                    Spacer()
                    HStack(spacing: 10){
                        Text(state.currentTimeString ?? "--:--")
                            .frame(width: 160)
                            .padding()
                            .edgesIgnoringSafeArea(.all)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .bottomLeading) {
                                Rectangle()
                                    .frame(height: 5)
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: (geometry.size.width * (Double(state.currentTime ?? 0) / Double(state.totalTime ?? 1))), height: 5)
                            }
                        }.frame(height: 5)
                        
                        Text(state.totalTimeString ?? "--:--")
                            .frame(width: 160)
                            .padding()
                            .edgesIgnoringSafeArea(.all)
                        
                    }
                    .padding()
                    .frame(
                        width: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.all)
                    .background(.ultraThinMaterial)
                }
            }
            
        }
        .onAppear {
            state.player.media = VLCMedia(url: URL(string: url)!)
            state.player.play()
            
        }
        
        .onDisappear{
            state.player.stop()
        }
        
        .focusable()
        
        // on press action
        .onLongPressGesture(minimumDuration: 0.01, perform:
                                {
            playPauseVideo()
        })
        
        .onPlayPauseCommand
        {
            playPauseVideo()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea(.all)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(url: "http://192.168.1.104:3333/pith/stream/undefined/Series/Grey's%20Anatomy/Season%2019/Grey's%20Anatomy%20-%20S19E05%20-%20When%20I%20Get%20to%20the%20Border%20WEBRip-1080p.mkv").padding()
    }
}

