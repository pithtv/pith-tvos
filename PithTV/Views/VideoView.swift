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
    var player: VLCMediaPlayer?
    
    init() {
        
    }
    
    func load() {
        self.player = VLCMediaPlayer()
        self.playerTimeChangedNotification = NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: VLCMediaPlayerTimeChanged),
            object: player,
            queue: nil,
            using: self.playerTimeChanged)
    }
    
    func unload() {
        NotificationCenter.default.removeObserver(playerTimeChangedNotification as Any)
    }
    
    func playerTimeChanged(_ notification: Notification) {
        self.currentTimeString = player!.time.stringValue
        self.currentTime = player!.time.intValue
        self.totalTimeString = player!.media?.length.stringValue
        self.totalTime = player!.media?.length.intValue
    }
}

struct VideoView: View {
    var pith: Pith
    var channel: String
    var itemId: String
    
    @State var isShowInfoPanel: Bool = false
    @State var error: String?
    
    @ObservedObject var state: PlayerState = PlayerState()
    
    func playPauseVideo()
    {
        if(state.player!.isPlaying)
        {
            state.player!.pause()
            isShowInfoPanel = true
        }
        else
        {
            state.player!.play()
            isShowInfoPanel = false
        }
    }
    
    var body: some View {
        if(error != nil) {
            Text(error!)
        } else {
            ZStack
            {
                if(state.player != nil) {
                    VlcPlayer(player: state.player!)
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
                        .focusable()
                        .onPlayPauseCommand {
                            playPauseVideo()
                        }
                    }
                } else {
                    ProgressView()
                }
                
            }
            .task {
                do {
                    let stream = try await pith.queryItemAndStream(channel: channel, itemId: itemId);
                    state.load()
                    state.player!.media = VLCMedia(url: URL(string: stream.stream.url)!)
                    state.player!.play()
                } catch let e {
                    print(e)
                    error = "An unknown error occured \(e)"
                }
            }
            
            .onDisappear{
                state.player?.stop()
                state.unload()
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
}

class PithMock : Pith {
    
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(pith: PithMock(baseUrl: URL(string: "http://horace:3333")!), channel: "files", itemId: "test").padding()
    }
}

