//
//  ContentView.swift
//  PithTV
//
//  Created by Christoph Cantillon on 03/11/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(channels) {
                                channel in
                                NavigationLink(channel.title, destination: Text("Test"))
                            }
                        }
                    }
                    ForEach(ribbons) {
                        ribbon in
                        Text(ribbon.name)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(recentlyAdded, id: \.item.id) {
                                    ribbonItem in
                                    NavigationLink(destination: {VideoView(url: videoUrl)}) {
                                        if let poster = ribbonItem.item.poster {
                                            AsyncImage(
                                                url: URL(string: poster),
                                                content: {
                                                    img in img
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                },
                                                placeholder: {
                                                    ProgressView()
                                                })
                                            .frame(width: 200, height: 300)
                                        }
                                    }
                                    .buttonStyle(CardButtonStyle())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
