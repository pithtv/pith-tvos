//
//  ChannelBrowser.swift
//  PithTV
//
//  Created by Christoph Cantillon on 11/11/2022.
//

import Foundation
import SwiftUI

struct ChannelBrowser: View {
    var pith: Pith
    var channelId: String
    var item: ChannelItem?
    @State var children: [ChannelItem]?
    
    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        if(children == nil && item?.type != .file) {
            ProgressView().task {
                do {
                    children = try await pith.listChannel(
                        channelId: channelId, containerId: item?.id)
                } catch let e {
                    print("Error \(e)")
                }
            }
        } else {
            ScrollView {
                VStack {
                    if item != nil {
                        ChannelItemDetails(pith: pith, channelId: channelId, item: item!)
                    }
                    if(children != nil) {
                        switch(item?.mediatype) {
                        case .show, .season:
                            ForEach(children!) {
                                childItem in
                                
                                NavigationLink(destination: ChannelBrowser(pith: pith, channelId: channelId, item: childItem)) {
                                    Text(childItem.title)
                                }
                            }
                        default:
                            LazyVGrid(columns: adaptiveColumns) {
                                ForEach(children!) {childItem in
                                    NavigationLink(destination: ChannelBrowser(
                                        pith: pith,
                                        channelId: channelId,
                                        item: childItem
                                    )) {
                                        
                                        if let poster = childItem.posters?[0] {
                                            AsyncImage(url: pith.imgUrl(poster.url),
                                                       content: {
                                                img in img
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            },
                                                       placeholder: {
                                                ProgressView()
                                            })
                                            .frame(width: 260, height: 390)
                                        } else {
                                            Text(childItem.title)
                                        }
                                    }.buttonStyle(CardButtonStyle())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChannelBrowser_Previews: PreviewProvider {
    static var previews: some View {
        ChannelBrowser(pith: Pith(baseUrl: URL(string: "http://horace:3333")!), channelId: "radarr", children: radarr)
    }

}
