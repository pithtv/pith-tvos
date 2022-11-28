//
//  ChannelItemDetails.swift
//  PithTV
//
//  Created by Christoph Cantillon on 11/11/2022.
//

import Foundation
import SwiftUI

struct ChannelItemDetails : View {
    var pith: Pith
    var channelId: String
    var item: ChannelItem
    
    var body: some View {
        HStack(alignment: .top) {
            if let poster = item.posters?[0] {
                AsyncImage(url: pith.imgUrl(poster.url),
                           content: { img in img
                        .resizable()
                    .aspectRatio(contentMode: .fill) },
                           placeholder: {ProgressView() })
                .frame(width: 600, height: 900)
            }
            VStack(alignment: .leading, spacing: 30) {
                Text(item.title)
                    .font(.largeTitle)
                if let rating = item.rating {
                    Text("\(String(repeating: "★", count: Int(rating / 2))) \(String(format: "%0.1f", rating))")
                }
                Text(item.overview ?? "")
                if(item.playable ?? false) {
                    NavigationLink(destination: VideoView(pith: pith, channel: channelId, item: item)) {
                        Label("Play", systemImage: "play")
                    }
                }
            }
        }
        .padding(40)
        .background(Backdrop(pith: pith, item: item))
    }
}

struct ChannelItemDetails_Previews : PreviewProvider {
    static var previews: some View {
        ChannelItemDetails(pith: Pith(baseUrl: URL(string: "http://horace:3333")!),
                           channelId: "radarr",
                           item: jurassicPark
        )
    }
}
