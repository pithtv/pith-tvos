//
//  ContentView.swift
//  PithTV
//
//  Created by Christoph Cantillon on 03/11/2022.
//

import SwiftUI

struct RibbonItemView : View {
    var pith: Pith
    var ribbonItem: RibbonItem
    
    var body: some View {
        NavigationLink(destination: {VideoView(pith: pith, channel: ribbonItem.channelId, itemId: ribbonItem.item.id)}) {
            if let poster = ribbonItem.item.poster {
                AsyncImage(
                    url: pith.imgUrl(poster),
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

struct ContentView: View {
    @ObservedObject var pith: Pith
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(pith.channels ?? []) {
                                channel in
                                NavigationLink(channel.title, destination: Text("Test"))
                            }
                        }
                    }
                    ForEach(pith.ribbons ?? []) {
                        ribbon in
                        Text(ribbon.name)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(pith.ribbonItems[ribbon.id] ?? [], id: \.item.id) {
                                    ribbonItem in
                                    RibbonItemView(pith: pith, ribbonItem: ribbonItem)
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            do {
                try await pith.load()
            } catch let error {
                print("Error from pith \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(pith: Pith(baseUrl: URL(string: "http://horace:3333")!))
    }
}
