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
        VStack {
            Text(item.title)
            if(item.playable ?? false) {
                NavigationLink(destination: VideoView(pith: pith, channel: channelId, itemId: item.id)) {
                    Text("Play")
                }
            }
        }
    }
}
