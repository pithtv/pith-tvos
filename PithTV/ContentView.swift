//
//  ContentView.swift
//  PithTV
//
//  Created by Christoph Cantillon on 03/11/2022.
//

import SwiftUI

func playItem(item: ChannelItem) {
    
}

struct ContentView: View {
    var body: some View {
        HStack {
            List(channels) { channel in
                Text(channel.title)
            }.frame(width: 250)
            List(ribbons) {
                ribbon in
                Text(ribbon.name)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(recentlyAdded, id: \.item.id) {
                            ribbonItem in
                            Button(action: {
                                playItem(item: ribbonItem.item)
                            }) {
                                if let poster = ribbonItem.item.poster {
                                    AsyncImage(url: URL(string: poster),
                                               content: {img in img.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 300)})
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Text")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
